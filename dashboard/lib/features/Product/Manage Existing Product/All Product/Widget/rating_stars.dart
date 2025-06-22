import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.color = const Color(0xFFFFC107),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star_rounded
              : index < rating
              ? Icons.star_half_rounded
              : Icons.star_outline_rounded,
          color: color,
          size: size,
        );
      }),
    );
  }
}
