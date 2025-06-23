import 'package:dashboard/core/theme.dart';
import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final String currentRoute;
  final Function(String) onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    required this.currentRoute,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = currentRoute == route;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected ? Themes.bg : Themes.bg.withAlpha(150),
          size: isSelected ? 23 : 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Themes.bg : Themes.bg.withAlpha(150),
            fontSize: isSelected ? 18 : 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () => onTap(route),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
