import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/review_item.dart';

class CustomerReviews extends StatelessWidget {
  const CustomerReviews({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      ReviewData(
        name: 'Sarah Taylor',
        reviewText: 'Great quality T-Shirt, very comfortable!',
        rating: 4.5,
        time: '2 days ago',
      ),
      ReviewData(
        name: 'John Smith',
        reviewText: 'Nice design, but the size runs a bit large.',
        rating: 4.0,
        time: 'a week ago',
      ),
      ReviewData(
        name: 'John Smith',
        reviewText: 'Nice design, but the size runs a bit large.',
        rating: 4.0,
        time: 'a week ago',
      ),
      ReviewData(
        name: 'John Smith',
        reviewText: 'Nice design, but the size runs a bit large.',
        rating: 4.0,
        time: 'a week ago',
      ),
      // Add more if needed
    ];

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
