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



    Future<Either<Failure, Map<String, dynamic>>> removeFromCart( String id ) async {
    try {
      Map<String, dynamic> response = await api.delete(endPoint: '/cart/$id', body: {});
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