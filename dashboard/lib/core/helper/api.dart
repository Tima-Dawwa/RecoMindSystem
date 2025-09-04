import 'package:dashboard/core/helper/service_locator.dart';
import 'package:dashboard/features/Authentication/view%20model/auth_service.dart';
import 'package:dio/dio.dart';

class Api {
  Api(this._dio);
  final Dio _dio;
  final String baseUrl = 'https://ab5e12859e5d.ngrok-free.app';

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
