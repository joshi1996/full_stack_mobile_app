import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/auth_status.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/user.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_state.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    required this.currentUserResult,
    required this.logoutResult,
  });

  Either<Failure, User?> currentUserResult;
  final Either<Failure, Unit> logoutResult;
  int currentUserCalls = 0;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async =>
      const Right(User(id: '1', email: 'user@example.com', name: 'User'));

  @override
  Future<Either<Failure, Unit>> logout() async => logoutResult;

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    currentUserCalls++;
    return currentUserResult;
  }
}

void main() {
  blocTest<AuthBloc, AuthState>(
    'restores authenticated state only when the repository verifies a user',
    build: () => AuthBloc(
      _FakeAuthRepository(
        currentUserResult: const Right(
          User(id: '1', email: 'user@example.com', name: 'User'),
        ),
        logoutResult: const Right(unit),
      ),
    ),
    act: (bloc) => bloc.checkAuthStatus(),
    expect: () => [const AuthAuthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'keeps a retryable error when session verification fails',
    build: () => AuthBloc(
      _FakeAuthRepository(
        currentUserResult: const Left(NetworkFailure('offline')),
        logoutResult: const Right(unit),
      ),
    ),
    act: (bloc) => bloc.checkAuthStatus(),
    expect: () => [const AuthRestoreFailed(NetworkFailure('offline'))],
  );

  blocTest<AuthBloc, AuthState>(
    'retries session verification and authenticates after a transient failure',
    build: () => AuthBloc(
      _FakeAuthRepository(
        currentUserResult: const Left(NetworkFailure('offline')),
        logoutResult: const Right(unit),
      ),
    ),
    act: (bloc) async {
      await bloc.checkAuthStatus();
      (bloc.repository as _FakeAuthRepository).currentUserResult = const Right(
        User(id: '1', email: 'user@example.com', name: 'User'),
      );
      await bloc.checkAuthStatus();
    },
    expect: () => [
      const AuthRestoreFailed(NetworkFailure('offline')),
      const AuthInitial(),
      const AuthAuthenticated(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'restores unauthenticated state when no session exists',
    build: () => AuthBloc(
      _FakeAuthRepository(
        currentUserResult: const Right(null),
        logoutResult: const Right(unit),
      ),
    ),
    act: (bloc) => bloc.checkAuthStatus(),
    expect: () => [const AuthUnauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits unauthenticated only after logout succeeds',
    build: () => AuthBloc(
      _FakeAuthRepository(
        currentUserResult: const Right(null),
        logoutResult: const Right(unit),
      ),
    ),
    seed: () => const AuthAuthenticated(),
    act: (bloc) => bloc.logout(),
    expect: () => [const AuthUnauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'preserves authenticated status and exposes an error when token deletion fails',
    build: () => AuthBloc(
      _FakeAuthRepository(
        currentUserResult: const Right(null),
        logoutResult: const Left(
          CacheFailure('Unable to clear the saved session.'),
        ),
      ),
    ),
    seed: () => const AuthAuthenticated(),
    act: (bloc) => bloc.logout(),
    expect: () => [
      const AuthLogoutFailed(
        status: AuthStatus.authenticated,
        failure: CacheFailure('Unable to clear the saved session.'),
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'does not accept a login completion after a newer logout transition',
    build: () => AuthBloc(
      _FakeAuthRepository(
        currentUserResult: const Right(null),
        logoutResult: const Right(unit),
      ),
    ),
    act: (bloc) async {
      final revision = bloc.beginLoginAttempt();
      await bloc.logout();
      bloc.authenticated(attemptRevision: revision);
    },
    expect: () => [const AuthUnauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'does not accept a login completion after session expiry',
    build: () => AuthBloc(
      _FakeAuthRepository(
        currentUserResult: const Right(null),
        logoutResult: const Right(unit),
      ),
    ),
    act: (bloc) {
      final revision = bloc.beginLoginAttempt();
      bloc.sessionExpired();
      bloc.authenticated(attemptRevision: revision);
    },
    expect: () => [const AuthUnauthenticated()],
  );
}
