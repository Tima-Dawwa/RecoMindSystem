import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:recomindweb/core/go_router.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/cubit/auth_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget_password_services.dart';
import 'package:recomindweb/features/Cart/view%20model/cart_service.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_cubit.dart';
<<<<<<< HEAD
import 'package:recomindweb/features/ChatBot/view%20model/chatBot_services.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_cubit.dart';
=======
import 'package:recomindweb/features/Favourites/view%20model/cubit/favourites_cubit.dart';
import 'package:recomindweb/features/Favourites/view%20model/favourites_service.dart';
>>>>>>> hamzati
import 'package:recomindweb/features/Home/view%20model/cubit/home_cubit.dart';
import 'package:recomindweb/features/Home/view%20model/home_service.dart';
import 'package:recomindweb/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:recomindweb/features/Orders/view%20model/orders_services.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/all_products_service.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_cubit.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_cubit.dart';
import 'package:recomindweb/features/product_details/view%20model/product_details_service.dart';

void main() async {
  await setup();
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(getIt.get<AuthService>())),
        BlocProvider(create: (context) => HomeCubit(getIt.get<HomeService>())),
        BlocProvider(create: (context)=> ChatBotCubit(getIt.get<ChatBotService>())),
        BlocProvider(
          create: (context) => OrdersCubit(getIt.get<OrdersService>()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ForgotPasswordCubit(getIt.get<ForgetPasswordServices>()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ProductDetailsCubit(getIt.get<ProductDetailsService>()),
        ),
        BlocProvider(create: (context) => CartCubit(getIt.get<CartService>())),
        BlocProvider(
          create:
              (context) => AllProductsCubit(getIt.get<AllProductsService>()),
        ),
        BlocProvider(
          create: (context) => FavouritesCubit(getIt.get<FavouritesService>()),
        ),
      ],
      child: GetMaterialApp(
        getPages: routes,
        title: 'Trendova',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Themes.primary,
          fontFamily: 'CoconNext',
          scaffoldBackgroundColor: Themes.bg,
        ),
      ),
    );
  }
}
