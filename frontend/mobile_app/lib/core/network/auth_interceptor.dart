import 'package:dio/dio.dart';

import 'auth_session_coordinator.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionCoordinator);

  static const String requiresAuthExtra = 'requiresAuth';
  static const String authorizationHeader = 'Authorization';

  final AuthSessionCoordinator _sessionCoordinator;
  final Expando<Object> _sessionIdentities = Expando<Object>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[requiresAuthExtra] != true) {
      handler.next(options);
      return;
    }

    try {
      final session = await _sessionCoordinator.currentSession();
      if (session != null) {
        options.headers[authorizationHeader] = 'Bearer ${session.accessToken}';
        _sessionIdentities[options] = session.identity;
      }
      handler.next(options);
    } on Object catch (exception) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: exception,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isProtectedRequest =
        err.requestOptions.extra[requiresAuthExtra] == true;
    if (err.response?.statusCode == 401 && isProtectedRequest) {
      final sessionIdentity = _sessionIdentities[err.requestOptions];
      if (sessionIdentity != null) {
        try {
          await _sessionCoordinator.expireIfCurrentSession(sessionIdentity);
        } on Object {
          // Keep the original 401 as the request error if storage is unavailable.
        }
      }
    }

    handler.next(err);
  }
}
