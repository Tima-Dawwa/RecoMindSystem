import 'package:dashboard/core/helper/service_locator.dart';
import 'package:dashboard/dashboard.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/add_product_service.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/cubit/add_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main Page/main_page.dart';
import 'package:dashboard/features/Product/Add Product/view/add_product.dart';
import 'package:dashboard/features/Product/Manage Existing Product/All Product/manage_product.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Setup service locator
  await setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddProductCubit(getIt.get<AddProductService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Trendova Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'CoconNext',
          scaffoldBackgroundColor: Themes.bg,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Dashboard(),
        routes: {
          '/dashboard': (context) => Dashboard(),
          '/main_page': (context) => MainPageScreen(),
          '/product/add': (context) => AddProduct(),
          '/product/manage': (context) => ManageProducts(),
          // '/orders': (context) => OrderPageScreen(),
          // '/ai_page': (context) => AIPageScreen(),
        },
      ),
    );
  }
}
