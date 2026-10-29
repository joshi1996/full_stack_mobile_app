import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/error/app_exception.dart';
import 'package:full_stack_mobile_app/core/error/failure_mapper.dart';
import 'package:full_stack_mobile_app/core/network/auth_session_coordinator.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.remoteDataSource, this.sessionCoordinator);

  final AuthRemoteDataSource remoteDataSource;
  final AuthSessionCoordinator sessionCoordinator;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final attempt = await sessionCoordinator.beginLoginAttempt();
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      final committed = await sessionCoordinator.commitLoginAttempt(
        attempt,
        userModel.accessToken,
      );
      if (!committed) {
        return const Left(
          NetworkFailure(
            'This login attempt was superseded. Please try again.',
          ),
        );
      }

      return Right(userModel.user.toEntity());
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    await sessionCoordinator.invalidateLoginAttempts();
    try {
      await remoteDataSource.logout();
    } on Object {
      // Local logout must still complete if a future remote logout fails.
    }

    try {
      await sessionCoordinator.clearAccessToken();
      return Right(unit);
    } on Object catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    AuthSessionSnapshot? session;
    try {
      session = await sessionCoordinator.currentSession();
      if (session == null) {
        return const Right(null);
      }

      final userModel = await remoteDataSource.getCurrentUser();
      if (!await sessionCoordinator.isCurrentSession(session.identity)) {
        return const Left(
          NetworkFailure(
            'The session changed while being verified. Try again.',
          ),
        );
      }
      return Right(userModel.toEntity());
    } on AuthenticationException {
      if (session == null) return const Right(null);

      try {
        await sessionCoordinator.expireIfCurrentSession(session.identity);
        final currentSession = await sessionCoordinator.currentSession();
        if (currentSession != null) {
          return const Left(
            NetworkFailure(
              'The session changed while being verified. Try again.',
            ),
          );
        }
      } on Object catch (exception) {
        return Left(FailureMapper.fromException(exception));
      }
      return const Right(null);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }
}
