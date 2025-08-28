import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class HomeService {
  final Api api;
  HomeService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> getCollab() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/products/collaborative',
      );
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

  Future<Either<Failure, Map<String, dynamic>>> getProfile() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/users/profile',
      );
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

  Future<Either<Failure, Map<String, dynamic>>> changeImage({
    required dynamic body,
  }) async {
    try {
      Map<String, dynamic> response = await api.put(
        endPoint: "/users/profile-pic",
        body: body,
      );
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(
          Failure.fromDioException(e, DefaultStatusCodeHandler())
        );
      } else {
        return left(Failure(errMessage: 'Something went wrong'));
      }
    }
  }

}
