import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';

import 'package:full_stack_mobile_app/features/auth/domain/entities/user.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/domain/usecases/login.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    return const Right(User(id: '1', email: 'amit@example.com', name: 'Amit'));
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return Right(unit);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return const Right(null);
  }
}

void main() {
  test('Login returns user from repository', () async {
    final repository = FakeAuthRepository();
    final login = Login(repository);

    final result = await login(email: 'amit@example.com', password: 'password');

    expect(result.isRight(), isTrue);

    result.fold((failure) => fail(failure.message), (user) {
      expect(user.id, '1');
      expect(user.email, 'amit@example.com');
      expect(user.name, 'Amit');
    });
  });
}
