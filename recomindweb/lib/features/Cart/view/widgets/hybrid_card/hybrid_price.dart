import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class HybridPrice extends StatelessWidget {
  final double price;
  final double discPrice;
  final bool isDisc;

  const HybridPrice({
    super.key,
    required this.price,
    required this.discPrice,
    required this.isDisc,
  });

  @override
  Widget build(BuildContext context) {
    if (isDisc) {
      return Row(
        children: [
          Text(
            '\$${discPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Themes.text,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${(price).toStringAsFixed(2)}',
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: 12,
              color: Themes.text.withAlpha(100),
            ),
          ),
        ],
      );
    } else {
      return Text(
        '\$${price.toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Themes.text,
        ),
      );
    }
  }
}
