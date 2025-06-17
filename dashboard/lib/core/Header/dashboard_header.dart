import 'package:dashboard/core/utils/theme.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.dashboard_rounded, color: Themes.bg, size: 24),
          SizedBox(width: 12),
          Text(
            'DASHBOARD',
            style: TextStyle(
              color: Themes.bg,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
