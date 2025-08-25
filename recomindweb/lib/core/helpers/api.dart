// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';

class Api {
  Api(this._dio);
  final Dio _dio;
  final String baseUrl = 'https://0cba4fd215ba.ngrok-free.app';

  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjNiYWVmYTA3MWNkZGM4ODE2ZmI4NmJjNiIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6IkRhbmllbGxhIiwibGFzdF9uYW1lIjoiTWFjZWprb3ZpYyJ9LCJpYXQiOjE3NTYxMzA0OTIsImV4cCI6MTc1NjM4OTY5Mn0.DOVVH51HHODD5c6UUUJEgl7f-hg5Aof69s6P_yl2mmE";

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
