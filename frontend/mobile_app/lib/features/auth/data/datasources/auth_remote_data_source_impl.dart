import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return const UserModel(id: '1', email: 'amit@example.com', name: 'Amit');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel?> getCurrentUser() async {
    return null;
  }
}
