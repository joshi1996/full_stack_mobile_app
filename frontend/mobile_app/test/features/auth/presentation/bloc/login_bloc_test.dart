import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/user.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/domain/usecases/login.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_event.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_state.dart';

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
    return const Right(unit);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return const Right(null);
  }
}

void main() {
  group('LoginBloc', () {
    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginFailure] when login fails',
      build: () {
        final repository = FakeFailureAuthRepository();
        final login = Login(repository);

        return LoginBloc(login);
      },
      act: (bloc) => bloc.add(
        const LoginSubmitted(
          email: 'amit@example.com',
          password: 'wrong-password',
        ),
      ),
      expect: () => [
        const LoginLoading(),
        const LoginFailure(AuthenticationFailure('Invalid credentials')),
      ],
    );
  });
}

class FakeFailureAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    return const Left(AuthenticationFailure('Invalid credentials'));
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return const Right(null);
  }
}
