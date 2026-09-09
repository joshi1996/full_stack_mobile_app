import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';

import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, User?>> getCurrentUser();
}
