import 'package:dashboard/core/Header/dashboard_header.dart';
import 'package:dashboard/core/Sidebar/expandable_item.dart';
import 'package:dashboard/core/Sidebar/sidebar_item.dart';
import 'package:dashboard/core/Sidebar/sub_item.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  String currentRoute = '/dashboard';

  void _navigateToRoute(String route) {
    setState(() {
      currentRoute = route;
    });
    // print('Navigating to: $route');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
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
            child: Container(
              color: Themes.bg,
              child: Center(child: Text("tima")),
            ),
          ),
        ],
      ),
    );
  }
}
