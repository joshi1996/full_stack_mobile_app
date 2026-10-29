import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:full_stack_mobile_app/core/error/app_exception.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/network/auth_session_coordinator.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/models/auth_session_model.dart';
import 'package:full_stack_mobile_app/features/auth/data/models/user_model.dart';
import 'package:full_stack_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/user.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  AuthSessionModel session = const AuthSessionModel(
    accessToken: 'signed-access-token',
    tokenType: 'Bearer',
    expiresIn: 600,
    user: UserModel(id: '1', email: 'amit@example.com', name: 'Amit'),
  );
  UserModel currentUser = const UserModel(
    id: '1',
    email: 'amit@example.com',
    name: 'Amit',
  );
  Object? currentUserError;
  Object? logoutError;
  Future<void> Function()? beforeCurrentUser;
  Future<AuthSessionModel> Function(String email)? loginHandler;
  int currentUserCalls = 0;

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async => loginHandler == null ? session : loginHandler!(email);

  @override
  Future<void> logout() async {
    if (logoutError case final error?) throw error;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    currentUserCalls++;
    await beforeCurrentUser?.call();
    if (currentUserError case final error?) throw error;
    return currentUser;
  }
}

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  String? accessToken;
  bool failClear = false;
  bool removeBeforeClearFailure = false;
  bool failRead = false;

  @override
  Future<void> saveAccessToken(String token) async {
    accessToken = token;
  }

  @override
  Future<String?> readAccessToken() async {
    if (failRead) {
      throw const CacheException('Unable to read the saved session.');
    }
    return accessToken;
  }

  @override
  Future<void> clearAccessToken() async {
    if (failClear) {
      if (removeBeforeClearFailure) accessToken = null;
      throw const CacheException('Unable to clear the saved session.');
    }
    accessToken = null;
  }
}

void main() {
  late AuthRepositoryImpl repository;
  late FakeAuthRemoteDataSource remoteDataSource;
  late FakeAuthLocalDataSource localDataSource;
  late AuthSessionCoordinator sessionCoordinator;

  setUp(() {
    remoteDataSource = FakeAuthRemoteDataSource();
    localDataSource = FakeAuthLocalDataSource();
    sessionCoordinator = AuthSessionCoordinator(localDataSource);
    repository = AuthRepositoryImpl(remoteDataSource, sessionCoordinator);
  });

  tearDown(() async {
    await sessionCoordinator.dispose();
  });

  test('login stores the access token and returns the domain entity', () async {
    final result = await repository.login(
      email: 'amit@example.com',
      password: 'password',
    );

    expect(result.isRight(), isTrue);
    expect(localDataSource.accessToken, 'signed-access-token');
    result.fold((failure) => fail(failure.message), (user) {
      expect(user, isA<User>());
      expect(user.id, '1');
      expect(user.email, 'amit@example.com');
      expect(user.name, 'Amit');
    });
  });

  test('login finishing after logout cannot persist its token', () async {
    final started = Completer<void>();
    final response = Completer<AuthSessionModel>();
    remoteDataSource.loginHandler = (_) {
      started.complete();
      return response.future;
    };

    final login = repository.login(email: 'amit@example.com', password: 'pw');
    await started.future;
    final logout = repository.logout();
    await logout;
    response.complete(remoteDataSource.session);

    final result = await login;
    expect(result.isLeft(), isTrue);
    expect(localDataSource.accessToken, isNull);
  });

  test(
    'the newest concurrent login attempt wins even when it finishes first',
    () async {
      final firstStarted = Completer<void>();
      final secondStarted = Completer<void>();
      final firstResponse = Completer<AuthSessionModel>();
      final secondResponse = Completer<AuthSessionModel>();
      remoteDataSource.loginHandler = (email) {
        if (email == 'first@example.com') {
          firstStarted.complete();
          return firstResponse.future;
        }
        secondStarted.complete();
        return secondResponse.future;
      };
      final first = repository.login(
        email: 'first@example.com',
        password: 'pw',
      );
      await firstStarted.future;
      final second = repository.login(
        email: 'second@example.com',
        password: 'pw',
      );
      await secondStarted.future;

      secondResponse.complete(_session('second-token'));
      expect((await second).isRight(), isTrue);
      firstResponse.complete(_session('first-token'));

      expect((await first).isLeft(), isTrue);
      expect(localDataSource.accessToken, 'second-token');
    },
  );

  test(
    'session restoration calls the server instead of trusting a cached user',
    () async {
      localDataSource.accessToken = 'signed-access-token';

      final result = await repository.getCurrentUser();

      expect(remoteDataSource.currentUserCalls, 1);
      result.fold((failure) => fail(failure.message), (user) {
        expect(user?.id, '1');
        expect(user?.email, 'amit@example.com');
      });
    },
  );

  test('does not call the server when there is no saved token', () async {
    final result = await repository.getCurrentUser();

    expect(remoteDataSource.currentUserCalls, 0);
    result.fold((failure) => fail(failure.message), (user) {
      expect(user, isNull);
    });
  });

  test(
    'clears an expired token and restores an unauthenticated result',
    () async {
      localDataSource.accessToken = 'expired-token';
      remoteDataSource.currentUserError = const AuthenticationException(
        'Authentication was rejected.',
      );

      final result = await repository.getCurrentUser();

      expect(localDataSource.accessToken, isNull);
      result.fold((failure) => fail(failure.message), (user) {
        expect(user, isNull);
      });
    },
  );

  test(
    'expiry clear failure before removal preserves session and failure',
    () async {
      localDataSource.accessToken = 'expired-token';
      localDataSource.failClear = true;
      remoteDataSource.currentUserError = const AuthenticationException(
        'Authentication was rejected.',
      );
      var expirations = 0;
      final subscription = sessionCoordinator.sessionExpired.listen(
        (_) => expirations++,
      );

      final result = await repository.getCurrentUser();

      expect(localDataSource.accessToken, 'expired-token');
      expect(expirations, 0);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected failure.'),
      );
      await subscription.cancel();
    },
  );

  test(
    'expiry clear failure after removal reconciles and publishes expiry',
    () async {
      localDataSource.accessToken = 'expired-token';
      localDataSource.failClear = true;
      localDataSource.removeBeforeClearFailure = true;
      remoteDataSource.currentUserError = const AuthenticationException(
        'Authentication was rejected.',
      );
      var expirations = 0;
      final subscription = sessionCoordinator.sessionExpired.listen(
        (_) => expirations++,
      );

      final result = await repository.getCurrentUser();

      expect(localDataSource.accessToken, isNull);
      expect(expirations, 1);
      expect(result.isRight(), isTrue);
      await subscription.cancel();
    },
  );

  test(
    'expiry is not claimed when storage cannot be reread after clear failure',
    () async {
      localDataSource.accessToken = 'expired-token';
      localDataSource.failClear = true;
      localDataSource.failRead = true;
      remoteDataSource.currentUserError = const AuthenticationException(
        'Authentication was rejected.',
      );
      var expirations = 0;
      final subscription = sessionCoordinator.sessionExpired.listen(
        (_) => expirations++,
      );

      final result = await repository.getCurrentUser();

      expect(expirations, 0);
      expect(result.isLeft(), isTrue);
      await subscription.cancel();
    },
  );

  test(
    'does not clear a newer token when an older session request is rejected',
    () async {
      localDataSource.accessToken = 'previous-session-token';
      remoteDataSource.beforeCurrentUser = () async {
        await sessionCoordinator.saveAccessToken('new-session-token');
        remoteDataSource.currentUserError = const AuthenticationException(
          'Authentication was rejected.',
        );
      };

      final result = await repository.getCurrentUser();

      expect(localDataSource.accessToken, 'new-session-token');
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected the stale response to be ignored as a failure.'),
      );
    },
  );

  test(
    'keeps the token on a network failure so restoration can be retried',
    () async {
      localDataSource.accessToken = 'signed-access-token';
      remoteDataSource.currentUserError = const NetworkException('offline');

      final result = await repository.getCurrentUser();

      expect(localDataSource.accessToken, 'signed-access-token');
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected a network failure.'),
      );
    },
  );

  test(
    'logout clears the token even when a remote logout operation fails',
    () async {
      localDataSource.accessToken = 'signed-access-token';
      remoteDataSource.logoutError = StateError('remote logout failed');

      final result = await repository.logout();

      expect(result.isRight(), isTrue);
      expect(localDataSource.accessToken, isNull);
    },
  );

  test(
    'returns a mapped cache failure if local credential clearing fails',
    () async {
      localDataSource.accessToken = 'signed-access-token';
      localDataSource.failClear = true;

      final result = await repository.logout();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected a cache failure.'),
      );
    },
  );
}

AuthSessionModel _session(String token) => AuthSessionModel(
  accessToken: token,
  tokenType: 'Bearer',
  expiresIn: 600,
  user: const UserModel(id: '1', email: 'amit@example.com', name: 'Amit'),
);
