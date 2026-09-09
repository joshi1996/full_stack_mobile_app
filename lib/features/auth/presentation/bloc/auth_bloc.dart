import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  AuthBloc(this.repository) : super(const AuthInitial());

  final AuthRepository repository;

  Future<void> checkAuthStatus() async {
    final result = await repository.getCurrentUser();

    result.fold(
      (_) {
        emit(const AuthUnauthenticated());
      },
      (user) {
        if (user == null) {
          emit(const AuthUnauthenticated());
        } else {
          emit(const AuthAuthenticated());
        }
      },
    );
  }

  void authenticated() {
    emit(const AuthAuthenticated());
  }

  Future<void> logout() async {
    final result = await repository.logout();

    result.fold(
      (_) {
        // We'll improve logout failure handling later.
      },
      (_) {
        emit(const AuthUnauthenticated());
      },
    );
  }
}
