import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<void> logout();

  Future<UserModel?> getCurrentUser();
}
