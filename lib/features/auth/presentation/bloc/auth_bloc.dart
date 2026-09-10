import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  AuthBloc(this.repository) : super(const AuthInitial());

  final AuthRepository repository;

  Future<void> checkAuthStatus() async {
    debugPrint('AUTH: checkAuthStatus START');

    try {
      final result = await repository.getCurrentUser();

      debugPrint('AUTH: getCurrentUser COMPLETED');

      result.fold(
        (failure) {
          debugPrint('AUTH: FAILURE -> ${failure.message}');
          emit(const AuthUnauthenticated());
        },
        (user) {
          debugPrint('AUTH: USER -> ${user?.email}');

          if (user == null) {
            debugPrint('AUTH: EMIT unauthenticated');
            emit(const AuthUnauthenticated());
          } else {
            debugPrint('AUTH: EMIT authenticated');
            emit(const AuthAuthenticated());
          }
        },
      );
    } catch (exception, stackTrace) {
      debugPrint('AUTH: EXCEPTION -> $exception');
      debugPrintStack(stackTrace: stackTrace);

      emit(const AuthUnauthenticated());
    }
  }

  // Future<void> checkAuthStatus() async {
  //   final result = await repository.getCurrentUser();

  //   result.fold(
  //     (_) {
  //       emit(const AuthUnauthenticated());
  //     },
  //     (user) {
  //       if (user == null) {
  //         emit(const AuthUnauthenticated());
  //       } else {
  //         emit(const AuthAuthenticated());
  //       }
  //     },
  //   );
  // }

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
