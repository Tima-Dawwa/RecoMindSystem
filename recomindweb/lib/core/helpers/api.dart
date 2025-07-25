// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';

class Api {
  Api(this._dio);
  final Dio _dio;
  final String baseUrl = 'http://localhost:5000';

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    var response = await _dio.get(
      '$baseUrl$endPoint',
      options: Options(
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4ODNkZTQxMGE1NzU3ODQ2ZDViNGM0ZCIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6IkpvaG4iLCJsYXN0X25hbWUiOiJEb2UifSwiaWF0IjoxNzUzNDcyNTc3LCJleHAiOjE3NTM3MzE3Nzd9.2gMQj3pZvKwrto8OYwqQMwhI8RubczID8DtTNAbom-s',
          // "ngrok-skip-browser-warning": "true",
        },
      ),
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
          'Authorization': 'Bearer ${getIt.get<AuthService>().token}',
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
          'Authorization': 'Bearer ${getIt.get<AuthService>().token}',
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
          'Authorization': 'Bearer ${getIt.get<AuthService>().token}',
        },
      ),
    );
    print(response.statusCode);
    print(response);
    return response.data;
  }
}
