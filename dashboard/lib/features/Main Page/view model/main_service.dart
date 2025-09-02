import 'package:dartz/dartz.dart';
import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/failure.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dio/dio.dart';

class MainService {
  final Api api;
  MainService(this.api);

    Future<Either<Failure, Map<String, dynamic>>> getSales() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/sales',
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

    Future<Either<Failure, Map<String, dynamic>>> getMostFavorited() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/favorites',
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

    Future<Either<Failure, Map<String, dynamic>>> getChatbotUsageType() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/chatbot',
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

    Future<Either<Failure, Map<String, dynamic>>> getMostUsersByCountry() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/top-countries',
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

    Future<Either<Failure, Map<String, dynamic>>> getTopCustomersByOrders() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/top-customers/orders',
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

    Future<Either<Failure, Map<String, dynamic>>> getTopCustomersByInteractions() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/top-customers/interactions',
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

    Future<Either<Failure, Map<String, dynamic>>> getNotifications() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/notifications/',
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

    Future<Either<Failure, Map<String, dynamic>>> deleteNotifications({required String id}) async {
    try {
      Map<String, dynamic> response = await api.delete(
        endPoint: '/dashboard/notifications/$id',
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