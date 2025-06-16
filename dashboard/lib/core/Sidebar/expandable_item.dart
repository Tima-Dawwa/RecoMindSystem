import 'package:flutter/material.dart';

class ExpandableItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const ExpandableItem({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ), 
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: Colors.grey[400], size: 20),
          title: Text(
            title,
            style: TextStyle(color: Colors.grey[300], fontSize: 14),
          ),
          iconColor: Colors.grey[400],
          collapsedIconColor: Colors.grey[400],
          tilePadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          childrenPadding:
              EdgeInsets.zero, 
          children: children,
        ),
      ),
    );
  }
}
