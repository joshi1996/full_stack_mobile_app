import 'package:dio/dio.dart';

import '../error/app_exception.dart';

abstract final class DioExceptionMapper {
  static AppException fromException(Object exception) {
    if (exception is AppException) return exception;
    if (exception is! DioException) {
      return const ServerException(
        'The authentication service could not complete the request.',
      );
    }

    if (exception.error is AppException) {
      return exception.error! as AppException;
    }

    final statusCode = exception.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return const AuthenticationException('Authentication was rejected.');
    }
    if (statusCode != null) {
      return const ServerException(
        'The server could not complete the request.',
      );
    }

    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => const NetworkException(
        'The request timed out. Please try again.',
      ),
      DioExceptionType.connectionError => const NetworkException(
        'Could not connect to the server. Check your connection and try again.',
      ),
      DioExceptionType.badCertificate => const NetworkException(
        'A secure connection to the server could not be established.',
      ),
      DioExceptionType.cancel => const NetworkException(
        'The request was cancelled.',
      ),
      DioExceptionType.badResponse || DioExceptionType.unknown =>
        const NetworkException('A network error occurred. Please try again.'),
    };
  }
}
