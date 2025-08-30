import 'package:dartz/dartz.dart';
import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/failure.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dio/dio.dart';

class AiStatisticsService {
   final Api api;

  AiStatisticsService(this.api);

  Future<Either<Failure, Map<String, dynamic>>> recommendationTime() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/recommendation/response-time'
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

  Future<Either<Failure, Map<String, dynamic>>> chatbotTime() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/chatbot/response-time'
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

  Future<Either<Failure, Map<String, dynamic>>> recommendationStatistics() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/recommendation/similarity'
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
  
  Future<Either<Failure, Map<String, dynamic>>> chatbotStatistics() async {
    try {
      Map<String, dynamic> response = await api.get(
        endPoint: '/dashboard/statistics/chatbot/similarity'
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