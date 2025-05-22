import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recomindweb/core/Widgets/app_scafold.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/all_products_page_desktop.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/all_products_page_mobile.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);
    return ResponsiveLayout(
      mobileBody: AppScaffold(child: AllProductsPageMobileLayout(tabController:tabController ,)),
      desktopBody: AppScaffold(child: AllProductsPageDesktopLayout(tabController: tabController,)),
    );
  }
}
