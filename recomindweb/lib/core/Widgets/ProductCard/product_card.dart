import 'package:flutter/material.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'product_image.dart';
import 'product_tags_row.dart';
import 'product_rating.dart';
import 'product_price.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({Key? key, required this.product, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(product: product),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTagsRow(product: product),
                  const SizedBox(height: 6),
                  ProductRating(rating: product.rating ?? 4.0),
                  const SizedBox(height: 6),
                  ProductPrice(price: product.price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
