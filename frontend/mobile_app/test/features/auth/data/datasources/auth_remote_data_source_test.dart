import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_stack_mobile_app/core/error/app_exception.dart';
import 'package:full_stack_mobile_app/core/network/api_client.dart';
import 'package:full_stack_mobile_app/core/network/auth_interceptor.dart';
import 'package:full_stack_mobile_app/core/network/access_token_storage.dart';
import 'package:full_stack_mobile_app/core/network/auth_session_coordinator.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';

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

ResponseBody _jsonResponse(Object? body, int statusCode) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  late Dio dio;
  late _MemoryTokenStorage tokenStorage;
  late AuthSessionCoordinator sessionCoordinator;
  late AuthRemoteDataSourceImpl dataSource;

  void configureDio(
    Future<ResponseBody> Function(RequestOptions options) respond,
  ) {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/'));
    dio.httpClientAdapter = _TestAdapter(respond);
    sessionCoordinator = AuthSessionCoordinator(tokenStorage);
    dio.interceptors.add(AuthInterceptor(sessionCoordinator));
    dataSource = AuthRemoteDataSourceImpl(ApiClient(dio));
  }

  setUp(() {
    tokenStorage = _MemoryTokenStorage('cached-token');
  });

  tearDown(() async {
    dio.close(force: true);
    await sessionCoordinator.dispose();
  });

  test(
    'login sends normalized credentials without requiring a token',
    () async {
      late RequestOptions capturedRequest;
      configureDio((options) async {
        capturedRequest = options;
        return _jsonResponse({
          'accessToken': 'signed-access-token',
          'tokenType': 'Bearer',
          'expiresIn': 600,
          'user': {
            'id': 'de5bc2c4-7e86-4b4f-98c0-19a6f5bc9921',
            'name': 'Test User',
            'email': 'customer@example.com',
          },
        }, 201);
      });

      final session = await dataSource.login(
        email: ' CUSTOMER@EXAMPLE.COM ',
        password: 'test-password',
      );

      expect(capturedRequest.uri.path, '/auth/login');
      expect(capturedRequest.data, {
        'email': 'customer@example.com',
        'password': 'test-password',
      });
      expect(capturedRequest.headers, isNot(contains('Authorization')));
      expect(session.accessToken, 'signed-access-token');
      expect(session.user.email, 'customer@example.com');
      expect(session.expiresIn, 600);
    },
  );

  test(
    '/auth/me attaches the saved token and parses the response envelope',
    () async {
      late RequestOptions capturedRequest;
      configureDio((options) async {
        capturedRequest = options;
        return _jsonResponse({
          'user': {
            'id': 'de5bc2c4-7e86-4b4f-98c0-19a6f5bc9921',
            'name': 'Test User',
            'email': 'customer@example.com',
          },
        }, 200);
      });

      final user = await dataSource.getCurrentUser();

      expect(capturedRequest.uri.path, '/auth/me');
      expect(
        capturedRequest.headers[AuthInterceptor.authorizationHeader],
        'Bearer cached-token',
      );
      expect(user.email, 'customer@example.com');
    },
  );

  test(
    'a 401 maps to an auth exception, clears the token, and is not retried',
    () async {
      var requestCount = 0;
      configureDio((_) async {
        requestCount++;
        return _jsonResponse({'message': 'Unauthorized'}, 401);
      });

      await expectLater(
        dataSource.getCurrentUser(),
        throwsA(isA<AuthenticationException>()),
      );

      expect(tokenStorage.token, isNull);
      expect(requestCount, 1);
    },
  );

  test('connection timeouts map to a safe network exception', () async {
    configureDio((options) async {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );
    });

    await expectLater(
      dataSource.login(email: 'customer@example.com', password: 'password'),
      throwsA(isA<NetworkException>()),
    );
  });

  test('malformed API JSON maps to a safe server exception', () async {
    configureDio((_) async => _jsonResponse({'unexpected': true}, 200));

    await expectLater(
      dataSource.login(email: 'customer@example.com', password: 'password'),
      throwsA(isA<ServerException>()),
    );
  });
}
