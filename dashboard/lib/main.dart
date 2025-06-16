import 'package:dashboard/dashboard.dart';
import 'package:dashboard/features/Main%20Page/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
