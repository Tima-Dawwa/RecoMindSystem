import 'package:flutter/material.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/model/product_Model.dart'; // Assuming this path for ProductModel
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/status_card.dart'; // Assuming this path for StatsCard
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view/widgets/rating_card.dart'; // Assuming this path for RatingCard

class BuildStatusProduct extends StatelessWidget {
  final ProductModel product; 

  const BuildStatusProduct({
    super.key,
    required this.product,
  }); 

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 700;

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Total Favorites',
                      value: (product.numFavorites).toString(),
                      icon: Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      title: 'Total Sales',
                      value: (product.numSales).toString(),
                      icon: Icons.shopping_cart,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Page Views',
                      value: (product.numViews).toString(),
                      icon: Icons.visibility,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RatingCard(
                      averageRating: product.ratings.averageRating,
                      reviewCount: product.ratings.count,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Total Favorites',
                  value: (product.numFavorites).toString(),
                  icon: Icons.favorite,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatsCard(
                  title: 'Total Sales',
                  value: (product.numSales).toString(),
                  icon: Icons.shopping_cart,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: StatsCard(
                  title: 'Page Views',
                  value: (product.numViews).toString(),
                  icon: Icons.visibility,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: RatingCard(
                  averageRating: product.ratings.averageRating,
                  reviewCount: product.ratings.count,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
