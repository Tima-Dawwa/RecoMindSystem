import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/dashboard.dart';
import 'package:dashboard/features/Main%20Page/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trendova Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'CoconNext',
        scaffoldBackgroundColor: Themes.bg,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(),
      // Define your routes here
      routes: {
        '/dashboard': (context) => Dashboard(),
        '/main_page': (context) => MainPageScreen(),
        // '/product/add': (context) => AddProductScreen(),
        // '/product/manage': (context) => ManageProductsScreen(),
        // '/orders': (context) => OrderPageScreen(),
        // '/ai_page': (context) => AIPageScreen(),
      },
    );
  }
}
