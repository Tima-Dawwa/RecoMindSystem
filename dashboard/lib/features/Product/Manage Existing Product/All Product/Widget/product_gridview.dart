import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductsGridView extends StatelessWidget {
  final List<Product> products;
  final Set<String> selectedProducts;
  final Function(String) onProductTap;
  final Function(String) onProductDoubleTap;

  const ProductsGridView({
    super.key,
    required this.products,
    required this.selectedProducts,
    required this.onProductTap,
    required this.onProductDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        if (screenWidth < 700) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                isSelected: selectedProducts.contains(product.id),
                onTap: () => onProductTap(product.id),
                onDoubleTap: () => onProductDoubleTap(product.id),
                isCompactView: true,
              );
            },
          );
        } else {
          int crossAxisCount;
          double childAspectRatio;
          double crossAxisSpacing = 16;
          double mainAxisSpacing = 16;

          if (screenWidth >= 1600) {
            crossAxisCount = 5;
            childAspectRatio = 0.95;
          } else if (screenWidth >= 1300) {
            crossAxisCount = 4;
            childAspectRatio = 0.95;
          } else if (screenWidth >= 1000) {
            crossAxisCount = 3;
            childAspectRatio = 0.95;
          } else {
            crossAxisCount = 2;
            childAspectRatio = 0.85;
            crossAxisSpacing = 12;
            mainAxisSpacing = 12;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                isSelected: selectedProducts.contains(product.id),
                onTap: () => onProductTap(product.id),
                onDoubleTap: () => onProductDoubleTap(product.id),
                isCompactView: false,
              );
            },
          );
        }
      },
    );
  }
}
