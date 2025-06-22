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

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          isSelected: selectedProducts.contains(product.id),
          onTap: () => onProductTap(product.id), 
          onDoubleTap:
              () => onProductDoubleTap(product.id), 
        );
      },
    );
  }
}
