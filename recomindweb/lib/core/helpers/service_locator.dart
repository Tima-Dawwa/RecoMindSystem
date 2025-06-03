import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton<Api>(Api(Dio()));
  getIt.registerSingleton<AuthService>(AuthService(getIt.get<Api>()));
  getIt.registerSingleton<DefaultStatusCodeHandler>(DefaultStatusCodeHandler());
}