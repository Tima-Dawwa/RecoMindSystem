import 'package:flutter/material.dart';
import 'package:recomindweb/core/Widgets/app_scafold.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Cart/view/widgets/cart_page_body.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ResponsiveLayout(
        mobileBody: CartPageBody(),
        desktopBody: CartPageBody(),
      ),
    );
  }
}
