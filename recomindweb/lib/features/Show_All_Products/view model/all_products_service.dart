import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class AllProductsService {
  final Api api;

  AllProductsService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> getAllProducts(
    int limit,
    int page,
  ) async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/products?limit=$limit&page=$page',
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
}
