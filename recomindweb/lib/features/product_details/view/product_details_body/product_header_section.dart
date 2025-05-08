import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Relaxed Fit T-Shirt",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            "Product Details",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Lorem ipsum flows with grace,"
            "Color dances, finds its place,"
            "In contrast, beauty shows its face.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
