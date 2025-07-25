import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/failure.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

class AuthService {
  final Api api;
  String? token;

  AuthService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> login({
    required String username,
    required String password,
  }) async {
    try {
      Map<String, dynamic> response = await api.post(
        endPoint: '/dashboard/admins/login',
        body: {'username': username, 'password': password},
      );
      token = response['token'];
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(Failure.fromDioException(e, DefaultStatusCodeHandler()));
      } else {
        return left(
          Failure(errMessage: 'something went wrong (not DioException)'),
        );
      }
    }
  }
}
