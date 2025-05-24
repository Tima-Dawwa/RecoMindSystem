import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/widgets/custom_tab_bar_view.dart';

class AllProductsPageMobileLayout extends StatelessWidget {
  const AllProductsPageMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SizedBox(height: 16), Expanded(child: CustomTabBarView())],
      ),
    );
  }
}
