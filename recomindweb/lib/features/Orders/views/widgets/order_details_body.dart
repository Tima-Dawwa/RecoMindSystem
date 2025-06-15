import 'package:flutter/material.dart';
import 'package:recomindweb/features/Orders/views/widgets/order_info.dart';
import 'package:recomindweb/features/Orders/views/widgets/products_table.dart';

class OrderDetailsBody extends StatelessWidget {
  const OrderDetailsBody({super.key, required this.desktop});
  final bool desktop;
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: desktop ? 25 : 15,
          horizontal: desktop ? 40 : 20,
        ),
        child: Column(
          children: [
            OrderInfo(
              state: 'delivered',
              orderNum: '3653',
              price: '1590',
              items: '26',
              desktop: desktop,
            ),
            SizedBox(height: 15),
            ProductsTable(desktop: desktop),
          ],
        ),
      ),
    );
  }
}
