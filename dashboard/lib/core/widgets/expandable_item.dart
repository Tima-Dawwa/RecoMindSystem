import 'package:dashboard/core/utils/theme.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: Themes.bg.withAlpha(150), size: 20),
          title: Text(
            title,
            style: TextStyle(color: Themes.bg.withAlpha(150), fontSize: 16),
          ),
          showTrailingIcon: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          childrenPadding: EdgeInsets.zero,
          children: children,
        ),
      ),
    );
  }
}
