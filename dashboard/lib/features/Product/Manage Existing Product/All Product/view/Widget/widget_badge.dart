import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String text;

    switch (status) {
      case 'trend':
        backgroundColor = const Color(0xFFFF6B35);
        text = 'TRENDING';
        break;
      case 'sale':
        backgroundColor = const Color(0xFFE53E3E);
        text = 'SALE';
        break;
      case 'out_of_stock':
        backgroundColor = const Color(0xFF718096);
        text = 'OUT OF STOCK';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
