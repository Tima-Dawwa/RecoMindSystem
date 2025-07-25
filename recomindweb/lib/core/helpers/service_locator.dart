import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/status_code_handler.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget_password_services.dart';
import 'package:recomindweb/features/Cart/view%20model/cart_service.dart';
import 'package:recomindweb/features/Home/view%20model/home_service.dart';
import 'package:recomindweb/features/Orders/view%20model/orders_services.dart';
import 'package:recomindweb/features/product_details/view%20model/product_details_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  
  getIt.registerSingleton<Api>(Api(Dio()));

  getIt.registerSingleton<AuthService>(AuthService(getIt.get<Api>()));

  getIt.registerSingleton<HomeService>(HomeService(getIt.get<Api>()));

  getIt.registerSingleton<OrdersService>(OrdersService(getIt.get<Api>()));

  getIt.registerSingleton<CartService>(CartService(getIt.get<Api>()));

  getIt.registerSingleton<DefaultStatusCodeHandler>(DefaultStatusCodeHandler());
  
  getIt.registerSingleton<ForgetPasswordServices>(
    ForgetPasswordServices(getIt.get<Api>()),
  );

  getIt.registerSingleton<ProductDetailsService>(
    ProductDetailsService(
      getIt.get<Api>(),
      getIt.get<DefaultStatusCodeHandler>(),
    ),
  );

}
