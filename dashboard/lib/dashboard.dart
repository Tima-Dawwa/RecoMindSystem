import 'package:dashboard/core/widgets/dashboard_header.dart';
import 'package:dashboard/core/widgets/expandable_item.dart';
import 'package:dashboard/core/widgets/sidebar_item.dart';
import 'package:dashboard/core/widgets/sub_item.dart';
import 'package:dashboard/core/theme.dart';
import 'package:dashboard/features/Main%20Page/main_page.dart';
import 'package:dashboard/features/Orders/view/orders_page.dart';
import 'package:dashboard/features/Product/Add%20Product/view/add_product.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/manage_product.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  String currentRoute = '/dashboard';

  Widget _getBodyForRoute(String route) {
    switch (route) {
      case '/dashboard':
        return Center(child: Text("Welcome to the Dashboard!"));
      case '/main_page':
        return MainPageScreen();
      case '/product/add':
        return AddProduct();
      case '/product/manage':
        return ManageProducts();
      case '/orders':
        return OrdersPage();
      //contiue all url here
      default:
        return Center(child: Text("Page Not Found"));
    }
  }

  void _navigateToRoute(String route) {
    setState(() {
      currentRoute = route;
    });

    print('Navigating to: $route');
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
                        onTap: _navigateToRoute,
                      ),
                      ExpandableItem(
                        icon: Icons.inventory_2_rounded,
                        title: 'Products Management',
                        children: [
                          SubItem(
                            title: 'Add Product',
                            route: '/product/add',
                            currentRoute: currentRoute,
                            onTap: _navigateToRoute,
                          ),
                          SubItem(
                            title: 'Modify Products',
                            route: '/product/manage',
                            currentRoute: currentRoute,
                            onTap: _navigateToRoute,
                          ),
                        ],
                      ),
                      SidebarItem(
                        icon: Icons.shopping_cart_rounded,
                        title: 'Orders Page',
                        route: '/orders',
                        currentRoute: currentRoute,
                        onTap: _navigateToRoute,
                      ),
                      SidebarItem(
                        icon: Icons.psychology_rounded,
                        title: 'AI Page',
                        route: '/ai_page',
                        currentRoute: currentRoute,
                        onTap: _navigateToRoute,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _getBodyForRoute(currentRoute),
          ),
        ],
      ),
    );
  }
}
