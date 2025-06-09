import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/models/review_model.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/review_item.dart';

class CustomerReviews extends StatelessWidget {
  final Product product;
  const CustomerReviews({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final List<Review> reviews =product.reviews;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Themes.text,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  reviews
                      .map(
                        (review) => SizedBox(
                          width:
                              isWide
                                  ? (constraints.maxWidth / 2) - 12
                                  : double.infinity,
                          child: ReviewItem(data: review),
                        ),
                      )
                      .toList(),
            );
          },
        ),
      ],
    );
  }
}
