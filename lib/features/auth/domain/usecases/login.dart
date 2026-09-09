import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
