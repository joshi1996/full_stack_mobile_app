sealed class LoginEvent {
  const LoginEvent();
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({
    required this.email,
    required this.password,
    this.authRevision,
  });

  final String email;
  final String password;
  final int? authRevision;
}
