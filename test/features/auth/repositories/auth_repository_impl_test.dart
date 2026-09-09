import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/models/user_model.dart';
import 'package:full_stack_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/user.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return const UserModel(id: '1', email: 'amit@example.com', name: 'Amit');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel?> getCurrentUser() async {
    return const UserModel(id: '1', email: 'amit@example.com', name: 'Amit');
  }
}

void main() {
  late AuthRepositoryImpl repository;

  setUp(() {
    repository = AuthRepositoryImpl(FakeAuthRemoteDataSource());
  });

  test('login converts UserModel to User entity', () async {
    final result = await repository.login(
      email: 'amit@example.com',
      password: 'password',
    );

    expect(result.isRight(), isTrue);

    result.fold((failure) => fail(failure.message), (user) {
      expect(user.id, '1');
      expect(user.email, 'amit@example.com');
      expect(user.name, 'Amit');
    });
  });

  test('getCurrentUser converts UserModel to User entity', () async {
    final result = await repository.getCurrentUser();

    expect(result.isRight(), isTrue);

    result.fold((failure) => fail(failure.message), (user) {
      expect(user, isA<User>());
      expect(user?.id, '1');
    });
  });

  test('logout delegates to data source', () async {
    await expectLater(repository.logout(), completes);
  });
}
