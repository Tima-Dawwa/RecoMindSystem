import 'package:flutter/material.dart';
import 'package:recomindweb/core/Widgets/app_scafold.dart';
import 'package:recomindweb/core/Widgets/responsive_layout.dart';
import 'package:recomindweb/features/Orders/views/widgets/order_details_body.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ResponsiveLayout(
        mobileBody: OrderDetailsBody(desktop: false),
        desktopBody: OrderDetailsBody(desktop: true),
      ),
    );
  }
}
