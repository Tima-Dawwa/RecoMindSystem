// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';

class Api {
  Api(this._dio);
  final Dio _dio;
  final String baseUrl = 'https://aababedef0c5.ngrok-free.app';
<<<<<<< Updated upstream
=======

  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4YmFkZWJiZTkwOThmNTM2NWZhZGUwZCIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6ImhhbXoiLCJsYXN0X25hbWUiOiJ0aSJ9LCJpYXQiOjE3NTcwODAyODgsImV4cCI6MTc1NzMzOTQ4OH0.BYsWN94rwjxx2bMBovvBL2cCDlecwuUtKOdlmX23s8c";

>>>>>>> Stashed changes

  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      '$baseUrl$endPoint',
      queryParameters: queryParameters,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${getIt.get<AuthService>().token}',
          "ngrok-skip-browser-warning": "false",
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
    dynamic body,
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
