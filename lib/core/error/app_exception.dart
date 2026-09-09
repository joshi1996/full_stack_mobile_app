abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class AuthenticationException extends AppException {
  const AuthenticationException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}
