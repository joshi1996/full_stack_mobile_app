import 'package:dio/dio.dart';

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> get(String path, {Options? options}) =>
      _dio.get<dynamic>(path, options: options);

  Future<Response<dynamic>> post(
    String path, {
    required Object? data,
    Options? options,
  }) => _dio.post<dynamic>(path, data: data, options: options);
}
