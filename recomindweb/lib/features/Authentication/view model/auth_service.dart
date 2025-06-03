import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class AuthService {
  final Api api;
  String? token;

  AuthService(this.api);

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

  Future<Either<Failure, Map<String, dynamic>>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String number,
    required String code,
    required String gender,
    required String birthDate,
  }) async {
    try {
      Map<String, dynamic> response = await api.post(
        endPoint: '/auth/register',
        body: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
          "date_of_birth": birthDate,
          "gender": gender,
          "phone": {"country_code": code, "number": number},
        },
      );
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(Failure.fromDioException(e, RegisterStatusCodeHandler()));
      }
      return left(Failure(errMessage: 'Something went wrong (not DioException)'));
    }
  }
}
