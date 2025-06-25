import 'package:dashboard/features/Orders/view/widgets/orders_page_body.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrdersPageBody());
  }
}
