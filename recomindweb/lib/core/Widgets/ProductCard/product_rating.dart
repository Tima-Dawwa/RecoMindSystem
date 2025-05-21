import 'package:flutter/material.dart';

class ProductRating extends StatelessWidget {
  final double rating;

  const ProductRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    const totalStars = 5;
    final fullStars = rating.floor();
    final halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(totalStars, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, size: 16, color: Colors.amber);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 16, color: Colors.grey);
        }
      }),
    );
  }
}
