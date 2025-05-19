import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/product_card.dart';
import '../Model/product.dart';

class ResponseCards extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onCardTap;

  const ResponseCards({
    required this.products,
    required this.onCardTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        int getCrossAxisCount() {
          if (screenWidth < 800) return 2;
          if (screenWidth < 1200) return 3;
          return 4;
        }

        if (screenWidth < 400) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                      minHeight: 200,
                    ),
                    child: ProductCard(
                      product: product,
                      onTap: () => onCardTap(product),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: MasonryGridView.count(
              crossAxisCount: getCrossAxisCount(),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              itemCount: products.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final product = products[index];
                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                    minHeight: 200,
                  ),
                  child: ProductCard(
                    product: product,
                    onTap: () => onCardTap(product),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
