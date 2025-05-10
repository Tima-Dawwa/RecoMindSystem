import 'package:flutter/material.dart';

class ColorOption extends StatelessWidget {
  final Color color;

  ColorOption({required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle color selection
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: color,
      ),
    );
  }
}
