// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';

class Api {
  Api(this._dio);
  final Dio _dio;
  final String baseUrl = 'https://f4b82fe1a1ff.ngrok-free.app';

String token= "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijg3Njg2ZmVhYzc2YjY4YjIwYjdlYWU0ZiIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6IkphbmUiLCJsYXN0X25hbWUiOiJZdW5kdCJ9LCJpYXQiOjE3NTQ1ODQwOTUsImV4cCI6MTc1NDg0MzI5NX0.dbkkO6lPSUcZM-cgRZi4WKsj_dzNfnD_PUDLCFwJ0ew";

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    var response = await _dio.get(
      '$baseUrl$endPoint',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          "ngrok-skip-browser-warning": "true",
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
          'Authorization': 'Bearer $token',
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
