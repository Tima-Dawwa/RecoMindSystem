import 'package:flutter/material.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/core/widgets/dashboard_header.dart';
import 'package:dashboard/core/widgets/expandable_item.dart';
import 'package:dashboard/core/widgets/sidebar_item.dart';
import 'package:dashboard/core/widgets/sub_item.dart';
import 'package:dashboard/features/AI/views/ai_page.dart';
import 'package:dashboard/features/Main%20Page/view/main_page.dart';
import 'package:dashboard/features/Orders/view/orders_page.dart';
import 'package:dashboard/features/Product/Add%20Product/view/add_product.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/manage_product.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  SideBarState createState() => SideBarState();
}

class SideBarState extends State<SideBar> {
  String currentRoute = '/main_page';

  Widget getBody(String route) {
    switch (route) {
      case '/main_page':
        return MainPage();
      case '/product/add':
        return AddProduct();
      case '/product/manage':
        return ManageProducts();
      case '/orders':
        return OrdersPage();
      case '/ai_page':
        return AiPage();
      default:
        return Center(child: Text("Page Not Found"));
    }
  }

  void goToPage(String page) {
    setState(() {
      currentRoute = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 270,
            color: Themes.primary,
            child: Column(
              children: [
                DashboardHeader(),
                Divider(color: Themes.bg.withAlpha(150), height: 1),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SidebarItem(
                        icon: Icons.home_rounded,
                        title: 'Main Page',
                        route: '/main_page',
                        currentRoute: currentRoute,
                        onTap: goToPage,
                      ),
                      ExpandableItem(
                        icon: Icons.inventory_2_rounded,
                        title: 'Products Management',
                        children: [
                          SubItem(
                            title: 'Add Product',
                            route: '/product/add',
                            currentRoute: currentRoute,
                            onTap: goToPage,
                          ),
                          SubItem(
                            title: 'Modify Products',
                            route: '/product/manage',
                            currentRoute: currentRoute,
                            onTap: goToPage,
                          ),
                        ],
                      ),
                      SidebarItem(
                        icon: Icons.shopping_cart_rounded,
                        title: 'Orders Archive',
                        route: '/orders',
                        currentRoute: currentRoute,
                        onTap: goToPage,
                      ),
                      SidebarItem(
                        icon: Icons.psychology_rounded,
                        title: 'AI Tools Performance',
                        route: '/ai_page',
                        currentRoute: currentRoute,
                        onTap: goToPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: getBody(currentRoute)),
        ],
      ),
    );
  }
}
