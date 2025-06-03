import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class LoginService {
  final Api api;
  String? token;

  LoginService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> response = await api.post(
        endPoint: '/auth/login',
        body: {'email': email, 'password': password},
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
