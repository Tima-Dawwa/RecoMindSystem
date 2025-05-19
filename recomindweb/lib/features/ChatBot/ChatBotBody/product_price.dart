import 'package:flutter/material.dart';

class ProductPrice extends StatelessWidget {
  final double? price;

  const ProductPrice({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    if (price == null) return const SizedBox();

    return Row(
      children: [
        Text(
          '\$${price!.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '\$${(price! * 1.2).toStringAsFixed(2)}',
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
