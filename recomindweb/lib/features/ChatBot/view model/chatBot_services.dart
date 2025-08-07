import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';

class ChatBotService {
  final Api api;
  final StatusCodeHandler statusCodeHandler;
  String? token;

  ChatBotService(this.api, this.statusCodeHandler);

  Future<Either<Failure, Map<String, dynamic>>> getAllChats() async {
    try {
      final response = await api.get(endPoint: '/chats');
      return right(response);
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> creatChat() async {
    try {
      final response = await api.post(endPoint: '/chats/create', body: null);
      return right(response);
    } on DioException catch (dioError) {
      return left(Failure.fromDioException(dioError, statusCodeHandler));
    } catch (e) {
      return left(
        Failure(errTitle: 'Unexpected Error', errMessage: e.toString()),
      );
    }
  }
}
