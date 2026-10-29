import 'package:equatable/equatable.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';

import '../../domain/entities/auth_status.dart';

sealed class AuthState extends Equatable {
  const AuthState(this.status);

  final AuthStatus status;

  @override
  List<Object?> get props => [status];
}

final class AuthInitial extends AuthState {
  const AuthInitial() : super(AuthStatus.unknown);
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated() : super(AuthStatus.authenticated);
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated() : super(AuthStatus.unauthenticated);
}

final class AuthRestoreFailed extends AuthState {
  const AuthRestoreFailed(this.failure) : super(AuthStatus.restorationFailed);

  final Failure failure;

  @override
  List<Object?> get props => [...super.props, failure];
}

final class AuthLogoutFailed extends AuthState {
  const AuthLogoutFailed({required AuthStatus status, required this.failure})
    : super(status);

  final Failure failure;

  @override
  List<Object?> get props => [...super.props, failure];
}
