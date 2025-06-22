import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/dashboard.dart';
import 'package:dashboard/features/Main%20Page/main_page.dart';
import 'package:dashboard/features/Product/Add%20Product/add_product.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/manage_product.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dashboard',
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
    );
  }
}
