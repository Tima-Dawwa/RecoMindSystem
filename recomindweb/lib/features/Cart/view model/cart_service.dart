import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class CartService {
  final Api api;

  CartService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> getCart() async {
    try {
      Map<String, dynamic> response = await api.get(endPoint: '/cart/');
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

  Future<Either<Failure, Map<String, dynamic>>> removeFromCart(
    String id,
  ) async {
    try {
      Map<String, dynamic> response = await api.delete(
        endPoint: '/cart/$id',
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

  Future<Either<Failure, Map<String, dynamic>>> makeOrder(dynamic body) async {
    try {
      Map<String, dynamic> response = await api.post(
        endPoint: '/orders',
        body: body,
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
      final response = await api.delete(
        endPoint: '/favorites/$favoriteId',
        body: null,
      );
      return right(response);
    } catch (e) {
      return left(
        Failure(errTitle: 'Error', errMessage: 'Failed to delete favorite: $e'),
      );
    }
  }
} 
