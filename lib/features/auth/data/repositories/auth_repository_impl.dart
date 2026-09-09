import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/error/failure_mapper.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await localDataSource.saveUser(userModel);

      return Right(userModel.toEntity());
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearUser();
      return Right(unit);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getSavedUser();

      return Right(userModel?.toEntity());
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }
}
