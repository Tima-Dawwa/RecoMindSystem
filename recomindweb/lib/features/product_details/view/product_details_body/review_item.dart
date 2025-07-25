import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/review_model.dart';



class ReviewItem extends StatelessWidget {
  final Review data;

  const ReviewItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Themes.bg,
      shadowColor: Themes.text,
      surfaceTintColor: Themes.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Themes.primary.withAlpha(40),
              child: Icon(Icons.person, color: Themes.bg),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Themes.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        data.createdAt,
                        style: TextStyle(
                          color: Themes.text.withAlpha(100),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < data.rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        size: 18,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.review ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Themes.text,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
