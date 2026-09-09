import 'package:equatable/equatable.dart';

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
