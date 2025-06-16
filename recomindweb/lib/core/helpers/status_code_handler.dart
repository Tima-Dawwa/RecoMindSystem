// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/failure.dart';

abstract class StatusCodeHandler {
  Failure handleError(int statusCode, dynamic data);
}

class DefaultStatusCodeHandler extends StatusCodeHandler {
  @override
  Failure handleError(int statusCode, data) {
    if (statusCode == 404) {
      print(statusCode);
      print(data.toString());
      return Failure(
        errTitle: 'Error',
        errMessage: data.toString(),
        errType: DioExceptionType.badResponse,
      );
    } else if (statusCode == 400 || statusCode == 401) {
      dynamic message;
      if (data.data is Map<String, dynamic>) {
        final dataMap = data.data as Map<String, dynamic>;
        message = dataMap['message'] ?? 'An error occurred';
      } else {
        message = 'An error occurred!';
        print(statusCode);
        print(data.data);
      }
      return Failure(
        errMessage: message,
        errTitle: 'Error',
        errType: DioExceptionType.badResponse,
      );
    } else {
      print(statusCode);
      return Failure(
        errTitle: 'Error',
        errMessage: data['message'],
        errType: DioExceptionType.badResponse,
      );
    }
  }
}

class RegisterStatusCodeHandler extends StatusCodeHandler {
  @override
  Failure handleError(int statusCode, data) {
    print(data);
    data = jsonDecode(data.toString());
    Map<String, dynamic> errors = data['errors'];
    if (errors['email'] != null) {
      return Failure(
        errTitle: errors.keys.first,
        errMessage: errors['email'].toString(),
      );
    } else {
      return Failure(
        errTitle: errors.keys.first,
        errMessage: errors[errors.keys.first][0],
      );
    }
  }
}
