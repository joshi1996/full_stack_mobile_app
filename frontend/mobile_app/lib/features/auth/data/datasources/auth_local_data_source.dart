import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);

  Future<UserModel?> getSavedUser();

  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this.storage);

  final FlutterSecureStorage storage;

  static const String _userKey = 'auth_user';

  @override
  Future<void> saveUser(UserModel user) async {
    await storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getSavedUser() async {
    final value = await storage.read(key: _userKey);

    if (value == null) {
      return null;
    }

    final json = jsonDecode(value) as Map<String, dynamic>;

    return UserModel.fromJson(json);
  }

  @override
  Future<void> clearUser() async {
    await storage.delete(key: _userKey);
  }
}
