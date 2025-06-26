import 'package:dashboard/core/helper/api.dart';
import 'package:dashboard/core/helper/status_code_handler.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/add_product_service.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_service.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Core dependencies
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<Api>(Api(getIt.get<Dio>()));
  getIt.registerSingleton<StatusCodeHandler>(DefaultStatusCodeHandler());

  // Services
  getIt.registerSingleton<AddProductService>(
    AddProductService(getIt.get<Api>(), getIt.get<StatusCodeHandler>()),
  );

  getIt.registerSingleton<AllProductService>(
    AllProductService(getIt.get<Api>(), getIt.get<StatusCodeHandler>()),
  );

  getIt.registerFactory<AllProductCubit>(
    () => AllProductCubit(getIt.get<AllProductService>()),
  );
}
