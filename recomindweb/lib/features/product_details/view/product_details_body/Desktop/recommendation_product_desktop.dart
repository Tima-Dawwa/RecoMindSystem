import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/recommedation_product.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_test.dart';

class RecommendationProductDesktop extends StatelessWidget {
  final List<Recommendation> products;

  const RecommendationProductDesktop({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Recommended Products",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Themes.text,
            ),
          ),
        ),
        MasonryGridView.count(
          crossAxisCount: 5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final Recommendation product = products[index];
            return GestureDetector(
              onTap: () {},
              child: ProductCard(product: product,),
            );
          },
        ),
      ],
    );
  }
}
