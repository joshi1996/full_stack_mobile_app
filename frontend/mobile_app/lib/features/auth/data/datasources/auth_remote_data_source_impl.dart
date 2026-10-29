import 'package:dio/dio.dart';
import 'package:full_stack_mobile_app/core/error/app_exception.dart';
import 'package:full_stack_mobile_app/core/network/api_client.dart';
import 'package:full_stack_mobile_app/core/network/api_endpoints.dart';
import 'package:full_stack_mobile_app/core/network/auth_interceptor.dart';
import 'package:full_stack_mobile_app/core/network/dio_exception_mapper.dart';

import '../models/auth_session_model.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email.trim().toLowerCase(), 'password': password},
      );
      return AuthSessionModel.fromJson(_asJsonObject(response.data));
    } on DioException catch (exception) {
      throw DioExceptionMapper.fromException(exception);
    } on AppException {
      rethrow;
    } on Object {
      throw const ServerException('The server returned an invalid response.');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.currentUser,
        options: Options(extra: {AuthInterceptor.requiresAuthExtra: true}),
      );
      final responseJson = _asJsonObject(response.data);
      final userJson = responseJson['user'];
      if (userJson is! Map<String, dynamic>) {
        throw const FormatException('Invalid user response.');
      }
      return UserModel.fromJson(userJson);
    } on DioException catch (exception) {
      throw DioExceptionMapper.fromException(exception);
    } on AppException {
      rethrow;
    } on Object {
      throw const ServerException('The server returned an invalid response.');
    }
  }

  @override
  Future<void> logout() async {
    // The backend has no logout endpoint; clearing the local token is logout.
  }

  Map<String, dynamic> _asJsonObject(Object? data) {
    if (data is Map<String, dynamic>) return data;
    throw const FormatException('Expected a JSON object.');
  }
}
