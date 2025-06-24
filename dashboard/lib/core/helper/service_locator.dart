import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/add_product_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton<Api>(Api(Dio()));

  getIt.registerSingleton<StatusCodeHandler>(DefaultStatusCodeHandler());

  getIt.registerSingleton<AddProductService>(
    AddProductService(getIt.get<Api>(), getIt.get<StatusCodeHandler>()),
  );
}
