import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class ForgetPasswordServices {
  final Api api;
  String? token;

  ForgetPasswordServices(this.api);

  Future<Either<Failure, Map<String, dynamic>>> forgetPassword({
    required String email,
  }) async {
    try {
      Map<String, dynamic> response = await api.post(
        endPoint: '/auth/forgot-password',
        body: {'email': email},
      );
      token = response['token'];
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(
          Failure.fromDioException(e, getIt.get<DefaultStatusCodeHandler>()),
        );
      } else {
        return left(Failure(errMessage: 'something went wrong'));
      }
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> verifyToken({
    required String email,

    required String code,
  }) async {
    try {
      Map<String, dynamic> response = await api.post(
        endPoint: '/auth/verify-token',
        body: {"email": email, "token": code},
      );
      token = response['token'];
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(
          Failure.fromDioException(e, getIt.get<DefaultStatusCodeHandler>()),
        );
      }
      return left(Failure(errMessage: 'Something went wrong '));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String email,

    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      Map<String, dynamic> response = await api.post(
        endPoint: '/auth/reset-password',
        body: {
          "email": email,
          "token": code,
          "password": password,
          "confirm_password": confirmPassword,
        },
      );
      token = response['token'];
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(
          Failure.fromDioException(e, getIt.get<DefaultStatusCodeHandler>()),
        );
      }
      return left(Failure(errMessage: 'Something went wrong '));
    }
  }
}
