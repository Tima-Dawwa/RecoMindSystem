import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class Failure {
  final String? errTitle;
  final dynamic errMessage;
  final DioExceptionType? errType;
  final StatusCodeHandler? handler;

  Failure({
    required this.errMessage,
    this.errTitle,
    this.errType,
    this.handler,
  });

  factory Failure.fromDioException(
    DioException dioException,
    StatusCodeHandler handler,
  ) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        print('dio exc error is : ${dioException..error.toString()}');
        return Failure(
          errTitle: 'Error',
          errMessage: "There seems to be a probleme with your Network Connection",
          errType: dioException.type,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return Failure(
          errTitle: 'Error',
          errMessage: "Something went wrong\nRefresh or try again later",
          errType: dioException.type,
        );
      case DioExceptionType.badResponse:
        return handler.handleError(
          dioException.response!.statusCode!,
          dioException.response,
        );
    }
  }
}
