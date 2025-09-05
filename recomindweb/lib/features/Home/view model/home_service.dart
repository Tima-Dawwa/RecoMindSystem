import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
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
      Map<String, dynamic> response = await api.get(endPoint: '/users/profile');
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
        return left(Failure.fromDioException(e, DefaultStatusCodeHandler()));
      } else {
        return left(Failure(errMessage: 'Something went wrong'));
      }
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> changeLocation({
    required dynamic body,
  }) async {
    try {
      Map<String, dynamic> response = await api.put(
        endPoint: "/users/location",
        body: body,
      );
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(Failure.fromDioException(e, DefaultStatusCodeHandler()));
      } else {
        return left(Failure(errMessage: 'Something went wrong'));
      }
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getCities() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: "/users/locations",
      );
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(
          Failure.fromDioException(e, getIt.get<DefaultStatusCodeHandler>()),
        );
      } else {
        return left(Failure(errMessage: 'Something went wrong'));
      }
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> logout() async {
    try {
      Map<String, dynamic> response = await api.post(
        endPoint: '/auth/logout',
        body: {},
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

  Future<Either<Failure, Map<String, dynamic>>> addToFavorites({
    required String productId,
  }) async {
    try {
      final response = await api.post(
        endPoint: '/favorites/$productId',
        body: null,
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

  Future<Either<Failure, Map<String, dynamic>>> deleteFavorite({
    required String favoriteId,
  }) async {
    try {
      final response = await api.delete(endPoint: '/favorites/$favoriteId');
      return right(response);
    } catch (e) {
      return left(
        Failure(errTitle: 'Error', errMessage: 'Failed to delete favorite: $e'),
      );
    }
  }
}
