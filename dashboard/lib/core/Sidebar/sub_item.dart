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
        color: isSelected ? Colors.blue[600] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.insert_drive_file,
          color: isSelected ? Colors.white : Colors.grey[500],
          size: 16,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () => onTap(route),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
    );
  }
}
