
import 'package:dashboard/core/Header/dashboard_header.dart';
import 'package:dashboard/core/Sidebar/expandable_item.dart';
import 'package:dashboard/core/Sidebar/sidebar_item.dart';
import 'package:dashboard/core/Sidebar/sub_item.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String currentRoute = '/dashboard';

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
          // Sidebar
          Container(
            width: 250,
            color: Color(0xFF2C3E50),
            child: Column(
              children: [
                // Header
                DashboardHeader(),
                Divider(color: Colors.grey[600], height: 1),
                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SidebarItem(
                        icon: Icons.home,
                        title: 'Main Page',
                        route: '/main_page',
                        currentRoute: currentRoute,
                        onTap: _navigateToRoute,
                      ),
                      ExpandableItem(
                        icon: Icons.inventory,
                        title: 'Product Management',
                        children: [
                          SubItem(
                            title: 'Add Product',
                            route: '/product/add',
                            currentRoute: currentRoute,
                            onTap: _navigateToRoute,
                          ),
                          SubItem(
                            title: 'Manage Products',
                            route: '/product/manage',
                            currentRoute: currentRoute,
                            onTap: _navigateToRoute,
                          ),
                        ],
                      ),
                      SidebarItem(
                        icon: Icons.shopping_cart,
                        title: 'Order Page',
                        route: '/orders',
                        currentRoute: currentRoute,
                        onTap: _navigateToRoute,
                      ),
                      SidebarItem(
                        icon: Icons.psychology,
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
              color: Colors.grey[100],
              child: Center(child: Text("tima"),),
            ),
          ),
        ],
      ),
    );
  }
}












