import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
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

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  UserModel? savedUser;

  @override
  Future<void> saveUser(UserModel user) async {
    savedUser = user;
  }

  @override
  Future<UserModel?> getSavedUser() async {
    return savedUser;
  }

  @override
  Future<void> clearUser() async {
    savedUser = null;
  }
}

void main() {
  late AuthRepositoryImpl repository;
  late FakeAuthLocalDataSource localDataSource;

  setUp(() {
    localDataSource = FakeAuthLocalDataSource();

    repository = AuthRepositoryImpl(
      FakeAuthRemoteDataSource(),
      localDataSource,
    );
  });

  test('login converts UserModel to User entity', () async {
    final result = await repository.login(
      email: 'amit@example.com',
      password: 'password',
    );

    expect(result.isRight(), isTrue);

    result.fold((failure) => fail(failure.message), (user) {
      expect(user, isA<User>());
      expect(user.id, '1');
      expect(user.email, 'amit@example.com');
      expect(user.name, 'Amit');
    });
  });

  test('login saves user locally for session restoration', () async {
    final result = await repository.login(
      email: 'amit@example.com',
      password: 'password',
    );

    expect(result.isRight(), isTrue);
    expect(localDataSource.savedUser, isNotNull);
    expect(localDataSource.savedUser?.id, '1');
    expect(localDataSource.savedUser?.email, 'amit@example.com');
    expect(localDataSource.savedUser?.name, 'Amit');
  });

  test('getCurrentUser converts saved UserModel to User entity', () async {
    localDataSource.savedUser = const UserModel(
      id: '1',
      email: 'amit@example.com',
      name: 'Amit',
    );

    final result = await repository.getCurrentUser();

    expect(result.isRight(), isTrue);

    result.fold((failure) => fail(failure.message), (user) {
      expect(user, isA<User>());
      expect(user?.id, '1');
      expect(user?.email, 'amit@example.com');
      expect(user?.name, 'Amit');
    });
  });

  test('getCurrentUser returns null when no saved session exists', () async {
    final result = await repository.getCurrentUser();

    expect(result.isRight(), isTrue);

    result.fold((failure) => fail(failure.message), (user) {
      expect(user, isNull);
    });
  });

  test('logout clears local session', () async {
    localDataSource.savedUser = const UserModel(
      id: '1',
      email: 'amit@example.com',
      name: 'Amit',
    );

    final result = await repository.logout();

    expect(result.isRight(), isTrue);
    expect(localDataSource.savedUser, isNull);
  });
}
