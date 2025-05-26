import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class SidebarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Themes.text.withAlpha(225),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu, color: Themes.bg),
              Icon(Icons.search, color: Themes.bg),
              Icon(Icons.delete_outline, color: Themes.bg),
            ],
          ),
          const SizedBox(height: 24),

          Text("Today", style: TextStyle(color: Themes.bg.withAlpha(100))),
          const SizedBox(height: 8),
          Text(
            "Interface Description Summary",
            style: TextStyle(color: Themes.bg),
          ),

          const SizedBox(height: 16),
          Text(
            "Previous 7 Days",
            style: TextStyle(color: Themes.bg.withAlpha(100)),
          ),
          const SizedBox(height: 8),
          ...[
            "Data Cleaning and Analysis",
            "Code Translation Request",
            "Flutter UI Code",
          ].map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(e, style: TextStyle(color: Themes.bg)),
            ),
          ),
        ],
      ),
    );
  }
}
