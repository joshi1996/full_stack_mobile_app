import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/network/access_token_storage.dart';
import 'package:full_stack_mobile_app/core/network/auth_interceptor.dart';
import 'package:full_stack_mobile_app/core/network/auth_session_coordinator.dart';
import 'package:full_stack_mobile_app/core/routing/auth_refresh_notifier.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/user.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_state.dart';

class _MemoryTokenStorage implements AccessTokenStorage {
  _MemoryTokenStorage(this.token);

  String? token;
  int clearCount = 0;

  @override
  Future<void> saveAccessToken(String token) async {
    this.token = token;
  }

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> clearAccessToken() async {
    clearCount++;
    token = null;
  }
}

class _TestAdapter implements HttpClientAdapter {
  _TestAdapter(this.respond);

  final Future<ResponseBody> Function(RequestOptions options) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);

  @override
  void close({bool force = false}) {}
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async =>
      const Right(User(id: '1', email: 'user@example.com', name: 'User'));

  @override
  Future<Either<Failure, Unit>> logout() async => const Right(unit);

  @override
  Future<Either<Failure, User?>> getCurrentUser() async => const Right(null);
}

ResponseBody _unauthorized() => ResponseBody.fromString(
  jsonEncode({'message': 'Unauthorized'}),
  401,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

Future<Response<dynamic>> _protectedRequest(Dio dio) => dio.get<dynamic>(
  '/protected',
  options: Options(extra: {AuthInterceptor.requiresAuthExtra: true}),
);

void main() {
  late Dio dio;
  late _MemoryTokenStorage tokenStorage;
  late AuthSessionCoordinator sessionCoordinator;

  setUp(() {
    tokenStorage = _MemoryTokenStorage('initial-session-token');
    sessionCoordinator = AuthSessionCoordinator(tokenStorage);
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/'));
    dio.interceptors.add(AuthInterceptor(sessionCoordinator));
  });

  tearDown(() async {
    dio.close(force: true);
    await sessionCoordinator.dispose();
  });

  test(
    'a protected 401 invalidates its session and synchronizes AuthBloc',
    () async {
      dio.httpClientAdapter = _TestAdapter((_) async => _unauthorized());
      final authBloc = AuthBloc(_FakeAuthRepository());
      authBloc.authenticated(attemptRevision: authBloc.beginLoginAttempt());
      final refreshNotifier = AuthRefreshNotifier(authBloc, sessionCoordinator);
      var routerRefreshes = 0;
      refreshNotifier.addListener(() => routerRefreshes++);

      await expectLater(_protectedRequest(dio), throwsA(isA<DioException>()));

      expect(tokenStorage.token, isNull);
      expect(authBloc.state, isA<AuthUnauthenticated>());
      expect(routerRefreshes, 1);

      refreshNotifier.dispose();
      await authBloc.close();
    },
  );

  test('a stale 401 cannot clear a newer login session', () async {
    final response = Completer<ResponseBody>();
    final requestStarted = Completer<void>();
    dio.httpClientAdapter = _TestAdapter((_) {
      requestStarted.complete();
      return response.future;
    });
    var expirations = 0;
    final subscription = sessionCoordinator.sessionExpired.listen((_) {
      expirations++;
    });

    final pendingRequest = _protectedRequest(dio);
    await requestStarted.future;
    await sessionCoordinator.saveAccessToken('new-session-token');
    response.complete(_unauthorized());

    await expectLater(pendingRequest, throwsA(isA<DioException>()));

    expect(tokenStorage.token, 'new-session-token');
    expect(tokenStorage.clearCount, 0);
    expect(expirations, 0);
    await subscription.cancel();
  });

  test('concurrent 401 responses expire one session only once', () async {
    final bothRequestsStarted = Completer<void>();
    var startedRequests = 0;
    dio.httpClientAdapter = _TestAdapter((_) async {
      startedRequests++;
      if (startedRequests == 2) bothRequestsStarted.complete();
      await bothRequestsStarted.future;
      return _unauthorized();
    });
    var expirations = 0;
    final subscription = sessionCoordinator.sessionExpired.listen((_) {
      expirations++;
    });

    await expectLater(
      Future.wait([_protectedRequest(dio), _protectedRequest(dio)]),
      throwsA(isA<DioException>()),
    );

    expect(tokenStorage.token, isNull);
    expect(tokenStorage.clearCount, 1);
    expect(expirations, 1);
    await subscription.cancel();
  });

  test(
    'public requests do not attach or invalidate an existing token',
    () async {
      late RequestOptions request;
      dio.httpClientAdapter = _TestAdapter((options) async {
        request = options;
        return _unauthorized();
      });
      var expirations = 0;
      final subscription = sessionCoordinator.sessionExpired.listen((_) {
        expirations++;
      });

      await expectLater(
        dio.get<dynamic>('/public'),
        throwsA(isA<DioException>()),
      );

      expect(request.headers[AuthInterceptor.authorizationHeader], isNull);
      expect(tokenStorage.token, 'initial-session-token');
      expect(tokenStorage.clearCount, 0);
      expect(expirations, 0);
      await subscription.cancel();
    },
  );

  test(
    'non-401 server and network errors do not invalidate the session',
    () async {
      var requestCount = 0;
      dio.httpClientAdapter = _TestAdapter((options) async {
        requestCount++;
        if (requestCount == 1) {
          return ResponseBody.fromString('{}', 500);
        }
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        );
      });

      await expectLater(_protectedRequest(dio), throwsA(isA<DioException>()));
      await expectLater(_protectedRequest(dio), throwsA(isA<DioException>()));

      expect(tokenStorage.token, 'initial-session-token');
      expect(tokenStorage.clearCount, 0);
    },
  );
}
