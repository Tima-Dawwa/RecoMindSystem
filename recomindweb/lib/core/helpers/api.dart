// ignore_for_file: avoid_print
import 'package:dio/dio.dart';

class Api {
  Api(this._dio);
  final Dio _dio;
  final String baseUrl = 'https://5faa89093ca3.ngrok-free.app';

  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRiYzJjMzE3NTZhZmIzOWJiZGZiM2NhOCIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6IlJhbmRhbGwiLCJsYXN0X25hbWUiOiJCdWNrcmlkZ2UifSwiaWF0IjoxNzU2Nzk5MzU2LCJleHAiOjE3NTcwNTg1NTZ9.Eiv6dy4geSsg1VK94b6u3kuGRxC189yo__GUupQar2A";

  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      '$baseUrl$endPoint',
      queryParameters: queryParameters,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
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
    print('objectooooooo');
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
