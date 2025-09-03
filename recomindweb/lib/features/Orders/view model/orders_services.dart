import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class OrdersService {
  final Api api;
  OrdersService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> getAllOrders({
    required String sortBy,
    required String sortOrder,
  }) async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/orders/?sortBy=$sortBy&sortOrder=$sortOrder',
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

  Future<Either<Failure, Map<String, dynamic>>> getOneOrder({
    required String orderId,
  }) async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/orders/$orderId',
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
