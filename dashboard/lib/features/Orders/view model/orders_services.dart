import 'package:dartz/dartz.dart';
import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/failure.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dio/dio.dart';

class OrdersService {
  final Api api;
  OrdersService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> getAllOrders() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/orders',
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

  Future<Either<Failure, Map<String, dynamic>>> getStatistics() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/orders/statistics',
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
