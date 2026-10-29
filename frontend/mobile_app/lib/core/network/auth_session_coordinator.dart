import 'dart:async';

import 'access_token_storage.dart';

final class AuthSessionSnapshot {
  const AuthSessionSnapshot({
    required this.accessToken,
    required this.identity,
  });

  final String accessToken;
  final Object identity;
}

/// Serializes token changes and publishes a single event when a live session
/// is invalidated by a protected request.
class AuthSessionCoordinator implements AccessTokenStorage {
  AuthSessionCoordinator(this._storage);

  final AccessTokenStorage _storage;
  final StreamController<void> _sessionExpiredController =
      StreamController<void>.broadcast(sync: true);
  Future<void> _operationQueue = Future<void>.value();
  String? _currentToken;
  Object? _currentIdentity;
  int _loginGeneration = 0;

  Stream<void> get sessionExpired => _sessionExpiredController.stream;

  /// Starts a login attempt. Only the newest attempt may commit its token.
  Future<int> beginLoginAttempt() => _exclusive(() async => ++_loginGeneration);

  /// Invalidates every login request that was still in flight when logout began.
  Future<void> invalidateLoginAttempts() => _exclusive(() async {
    _loginGeneration++;
  });

  Future<bool> commitLoginAttempt(int generation, String token) =>
      _exclusive(() async {
        if (generation != _loginGeneration) return false;
        await _storage.saveAccessToken(token);
        _synchronizeIdentity(token, forceNewIdentity: true);
        return true;
      });

  Future<AuthSessionSnapshot?> currentSession() => _exclusive(() async {
    final token = await _storage.readAccessToken();
    _synchronizeIdentity(token);
    if (token == null || token.isEmpty) return null;

    return AuthSessionSnapshot(accessToken: token, identity: _currentIdentity!);
  });

  Future<bool> expireIfCurrentSession(Object rejectedIdentity) =>
      _exclusive(() async {
        final token = await _storage.readAccessToken();
        _synchronizeIdentity(token);
        if (token == null ||
            token.isEmpty ||
            !identical(_currentIdentity, rejectedIdentity)) {
          return false;
        }

        try {
          await _storage.clearAccessToken();
        } on Object catch (clearError, stackTrace) {
          final persistedToken = await _storage.readAccessToken();
          _synchronizeIdentity(persistedToken);
          if (persistedToken != null && persistedToken.isNotEmpty) {
            Error.throwWithStackTrace(clearError, stackTrace);
          }
          _currentToken = null;
          _currentIdentity = null;
          _sessionExpiredController.add(null);
          return true;
        }
        _currentToken = null;
        _currentIdentity = null;
        _sessionExpiredController.add(null);
        return true;
      });

  Future<bool> isCurrentSession(Object identity) => _exclusive(() async {
    final token = await _storage.readAccessToken();
    _synchronizeIdentity(token);
    return token != null &&
        token.isNotEmpty &&
        identical(_currentIdentity, identity);
  });

  @override
  Future<void> saveAccessToken(String token) async {
    final generation = await beginLoginAttempt();
    await commitLoginAttempt(generation, token);
  }

  @override
  Future<String?> readAccessToken() => _exclusive(() async {
    final token = await _storage.readAccessToken();
    _synchronizeIdentity(token);
    return token;
  });

  @override
  Future<void> clearAccessToken() => _exclusive(() async {
    await _storage.clearAccessToken();
    _currentToken = null;
    _currentIdentity = null;
  });

  Future<void> dispose() => _sessionExpiredController.close();

  void _synchronizeIdentity(String? token, {bool forceNewIdentity = false}) {
    final currentToken = token == null || token.isEmpty ? null : token;
    if (forceNewIdentity || currentToken != _currentToken) {
      _currentToken = currentToken;
      _currentIdentity = currentToken == null ? null : Object();
    }
  }

  Future<T> _exclusive<T>(Future<T> Function() operation) {
    final previous = _operationQueue;
    final release = Completer<void>();
    _operationQueue = release.future;

    return previous
        .then((_) => operation())
        .whenComplete(() => release.complete());
  }
}
