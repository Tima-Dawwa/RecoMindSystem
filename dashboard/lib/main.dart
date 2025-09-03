import 'package:dashboard/core/helper/go_router.dart';
import 'package:dashboard/features/AI/view%20model/ai_statistics_service.dart';
import 'package:dashboard/features/AI/view%20model/cubit/ai_statistics_cubit.dart';
import 'package:dashboard/features/Main%20Page/view%20model/cubit/main_cubit.dart';
import 'package:dashboard/features/Main%20Page/view%20model/main_service.dart';
import 'package:dashboard/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:dashboard/features/Orders/view%20model/orders_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Authentication/view%20model/auth%20cubit/auth_cubit.dart';
import 'package:dashboard/features/Authentication/view%20model/auth_service.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view%20model/cubit/product_mangment_cubit.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view%20model/manage_product_service.dart';
import 'package:dashboard/core/helper/service_locator.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/add_product_service.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/cubit/add_product_cubit.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_cubit.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view%20model/all_product_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(getIt.get<AuthService>())),
        BlocProvider(create: (context) => MainCubit(getIt.get<MainService>())),
        BlocProvider(
          create: (context) => OrdersCubit(getIt.get<OrdersService>()),
        ),
        BlocProvider(
          create: (context) => AiStatisticsCubit(getIt.get<AiStatisticsService>()),
        ),
        BlocProvider(
          create: (context) => AddProductCubit(getIt.get<AddProductService>()),
        ),
        BlocProvider(
          create: (context) => AllProductCubit(getIt.get<AllProductService>()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ManageProductCubit(getIt.get<ManageProductService>()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Trendova Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'CoconNext',
          scaffoldBackgroundColor: Themes.bg,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
