import 'package:flutter/material.dart';
import 'package:recomindweb/core/Widgets/ProductCard/product_card.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';

class GridAllProducts extends StatelessWidget {
  const GridAllProducts({super.key, required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual product data from your backend
    final List<Product> dummyProducts = List.generate(
      12,
      (index) => Product(
        name: 'Product ${index + 1}',
        price: (index + 1) * 100.0,
        rating: 4.0 + (index % 2 == 0 ? 0.5 : 0.0),
        imageUrl: 'assets/main_image.jpg',
        gender: 'male',
        category: 'ss',
      ),
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 280,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: dummyProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: dummyProducts[index],
              onTap: () {
                // TODO: Implement product detail navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Selected product: ${dummyProducts[index].name}',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
