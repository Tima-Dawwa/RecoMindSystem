import 'package:dashboard/core/utils/theme.dart';
import 'package:flutter/material.dart';

class SubItem extends StatelessWidget {
  final String title;
  final String route;
  final String currentRoute;
  final Function(String) onTap;

  const SubItem({
    super.key,
    required this.route,
    required this.title,
    required this.currentRoute,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = currentRoute == route;

    return Container(
      margin: EdgeInsets.only(left: 32, right: 8, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: isSelected ? Themes.bg : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.insert_drive_file_rounded,
          color: isSelected ? Themes.primary : Themes.bg.withAlpha(180),
          size: isSelected ? 23 : 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Themes.primary : Themes.bg.withAlpha(180),
            fontSize: isSelected ? 18 : 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () => onTap(route),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}
