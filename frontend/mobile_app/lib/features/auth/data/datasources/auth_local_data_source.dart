import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:full_stack_mobile_app/core/error/app_exception.dart';
import 'package:full_stack_mobile_app/core/network/access_token_storage.dart';

abstract interface class SecureKeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  const FlutterSecureKeyValueStore(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

abstract interface class AuthLocalDataSource implements AccessTokenStorage {
  @override
  Future<void> saveAccessToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  static const String _accessTokenKey = 'auth_access_token';

  final SecureKeyValueStore _storage;

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(_accessTokenKey, token);
    } on Object {
      throw const CacheException('Unable to securely save the session.');
    }
  }

  @override
  Future<String?> readAccessToken() async {
    try {
      return await _storage.read(_accessTokenKey);
    } on Object {
      throw const CacheException('Unable to read the saved session.');
    }
  }

  @override
  Future<void> clearAccessToken() async {
    try {
      await _storage.delete(_accessTokenKey);
    } on Object {
      throw const CacheException('Unable to clear the saved session.');
    }
  }
}
