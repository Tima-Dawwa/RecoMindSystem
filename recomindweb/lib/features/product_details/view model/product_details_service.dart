import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class ProductDetailsService {
  final Api api;
  final StatusCodeHandler statusCodeHandler;
  String? token;

  ProductDetailsService(this.api, this.statusCodeHandler);

  Future<Either<Failure, Map<String, dynamic>>> getOneProduct({
    required String productId,
  }) async {
    try {
      final response = await api.get(endPoint: '/products/$productId');
      return right(response);
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> addReview({
    required String productId,
    required int rating,
    required String commit,
  }) async {
    try {
      final response = await api.post(
        endPoint: '/products/$productId/rate',
        body: {"rating": rating, "review_text": commit},
      );
      return right(response);
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
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
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
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

  Future<Either<Failure, Map<String, dynamic>>> addToCart({
    required String productId,
    required int count,
  }) async {
    try {
      final response = await api.post(
        endPoint: '/cart/$productId',
        body: {"count": count},
      );
      return right(response);
    } catch (e) {
      return left(
        Failure(errTitle: 'Error', errMessage: 'Failed to add to cart: $e'),
      );
    }
  }
}
