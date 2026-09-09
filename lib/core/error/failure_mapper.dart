import 'app_exception.dart';
import 'failure.dart';

abstract final class FailureMapper {
  static Failure fromException(Object exception) {
    if (exception is AuthenticationException) {
      return AuthenticationFailure(exception.message);
    }

    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is ServerException) {
      return ServerFailure(exception.message);
    }

    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }

    return UnknownFailure(exception.toString());
  }
}
