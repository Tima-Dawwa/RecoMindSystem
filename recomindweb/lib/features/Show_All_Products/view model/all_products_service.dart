import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class AllProductsService {
  final Api api;

  AllProductsService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> getAllProducts({
    int? limit,
    int? page,
    String? type,
    double? maxPrice,
    double? minPrice,
    bool? isNew,
    bool? isTrend,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (isNew != null) queryParams['isNew'] = isNew;
      if (isTrend != null) queryParams['isTrend'] = isTrend;

      Map<String, dynamic> response = await api.get(
        endPoint: '/products',
        queryParameters: queryParams,
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


  Future<Either<Failure, Map<String, dynamic>>> smartSearch(
    String text
  ) async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/products/smart-search?search=$text',
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
