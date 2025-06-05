import 'package:dio/dio.dart';

class Api {
  Api(this._dio);

  final Dio _dio;
  final String baseUrl = 'http://localhost:5000';
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4NDFiNDU4MWJhNjhiNjQzZjgzYzI3MiIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6InRpbWEiLCJsYXN0X25hbWUiOiJEYXd3YSJ9LCJpYXQiOjE3NDkxMzY5NTYsImV4cCI6MTc0OTM5NjE1Nn0.M_7570rBJV4QYf7eSNCq2aMGpNIdVFimKXRMXXWhO4k";

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    var response = await _dio.get(
      '$baseUrl$endPoint',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print(response.statusCode);
    print(response);
    return response.data;
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    required dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.post(
      '$baseUrl$endPoint',
      data: body,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.statusCode);
    print(response);
    return response.data;
  }

  Future<Map<String, dynamic>> delete({
    required String endPoint,
    required dynamic body,
  }) async {
    var response = await _dio.delete(
      '$baseUrl$endPoint',
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.statusCode);
    print(response);
    return response.data;
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    required dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.put(
      '$baseUrl$endPoint',
      data: body,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(response.statusCode);
    print(response);
    return response.data;
  }
}
