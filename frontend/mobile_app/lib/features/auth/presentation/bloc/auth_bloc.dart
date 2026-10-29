import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';

import '../../domain/entities/auth_status.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  AuthBloc(this.repository) : super(const AuthInitial());

  final AuthRepository repository;
  int _sessionCheckRevision = 0;

  Future<void> checkAuthStatus() async {
    final revision = ++_sessionCheckRevision;
    if (state.status == AuthStatus.restorationFailed) {
      emit(const AuthInitial());
    }

    try {
      final result = await repository.getCurrentUser();
      if (revision != _sessionCheckRevision) return;

      result.fold((failure) => emit(AuthRestoreFailed(failure)), (user) {
        emit(
          user == null
              ? const AuthUnauthenticated()
              : const AuthAuthenticated(),
        );
      });
    } on Object {
      if (revision != _sessionCheckRevision) return;
      emit(
        const AuthRestoreFailed(
          NetworkFailure('Unable to verify your session. Please try again.'),
        ),
      );
    }
  }

  int beginLoginAttempt() => ++_sessionCheckRevision;

  void authenticated({required int attemptRevision}) {
    if (attemptRevision != _sessionCheckRevision) return;
    _sessionCheckRevision++;
    emit(const AuthAuthenticated());
  }

  void sessionExpired() {
    _sessionCheckRevision++;
    emit(const AuthUnauthenticated());
  }

  Future<void> logout() async {
    _sessionCheckRevision++;
    final result = await repository.logout();
    result.fold(
      (failure) =>
          emit(AuthLogoutFailed(status: state.status, failure: failure)),
      (_) {
        _sessionCheckRevision++;
        emit(const AuthUnauthenticated());
      },
    );
  }
}
