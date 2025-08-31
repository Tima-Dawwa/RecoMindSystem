import 'package:flutter/material.dart';
import 'package:recomindweb/core/utils.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';

class AllProductImage extends StatefulWidget {
  final AllProductsModel product;

  const AllProductImage({super.key, required this.product});

  @override
  State<AllProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<AllProductImage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: [
            Image.network(
              'https://29368a0364f1.ngrok-free.app/${product.imageUrl}',
              headers: {"ngrok-skip-browser-warning": "true"},
              fit: BoxFit.fill,
              width: double.infinity,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(child: Icon(Icons.image, size: 40)),
                  ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getTagColor(product.tagType),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product.tagType.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
