import 'package:flutter/material.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Orders/views/widgets/order_details_body.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: OrderDetailsBody(desktop: false),
        desktopBody: OrderDetailsBody(desktop: true),
      ),
    );
  }
}
