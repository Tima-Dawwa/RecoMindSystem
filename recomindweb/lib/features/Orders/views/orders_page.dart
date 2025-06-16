import 'package:flutter/material.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Orders/views/widgets/orders_page_body.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: OrdersPageBody(ordersNum: 3, desktop: false),
        desktopBody: OrdersPageBody(ordersNum: 3, desktop: true),
      ),
    );
  }
}
