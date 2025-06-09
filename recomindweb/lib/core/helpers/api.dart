import 'package:dio/dio.dart';

class Api {
  Api(this._dio);
//'http://localhost:5000'
  final Dio _dio;
  final String baseUrl = 'https://c4dd-190-2-147-86.ngrok-free.app';
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImU4YTU5ZjVlNzYzMGMwYzI4ZDBkZWJkYiIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6IkFsbGllIiwibGFzdF9uYW1lIjoiV2ViZXIifSwiaWF0IjoxNzQ5NDg3NDEwLCJleHAiOjE3NDk3NDY2MTB9.61iU7bhfiDg6i2xPTWSr5NAnw8KDPhTtCL2h7G9oOP8";

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    var response = await _dio.get(
      '$baseUrl$endPoint',
      options: Options(headers: {'Authorization': 'Bearer $token',"ngrok-skip-browser-warning":"true"}),
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
