import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.menu, color: Colors.white),
              Icon(Icons.search, color: Colors.white),
              Icon(Icons.delete_outline, color: Colors.white),
            ],
          ),
          const SizedBox(height: 24),

          Text("Today", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            "Interface Description Summary",
            style: TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 16),
          Text("Previous 7 Days", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          ...[
            "Data Cleaning and Analysis",
            "Code Translation Request",
            "Flutter UI Code",
          ].map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(e, style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
