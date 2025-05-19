import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'features/ChatBot/Model/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({required this.product, required this.onTap, Key? key})
    : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return _ResponsiveProductCard(
          product: widget.product,
          isWide: isWide,
          onTap: widget.onTap,
          isFavorite: isFavorite,
          onFavoriteToggle: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        );
      },
    );
  }
}

class _ResponsiveProductCard extends StatelessWidget {
  final Product product;
  final bool isWide;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _ResponsiveProductCard({
    required this.product,
    required this.isWide,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final originalPrice =
        product.discountPercent != null
            ? product.price * (1 + product.discountPercent! / 100)
            : product.price;

    final discountedPrice = product.price;
    final gender = product.gender.isNotEmpty ? product.gender : "Unisex";
    final category = product.category.isNotEmpty ? product.category : "General";
    final rating = product.rating;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 500,
        width: 500,
        margin: const EdgeInsets.all(8),
        constraints: BoxConstraints(
          maxWidth: isWide ? 400 : MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (product.isTrending)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "TREND",
                          style: TextStyle(
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
                      onTap: onFavoriteToggle,
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 16 : 12,
                vertical: 8,
              ),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isWide ? 18 : 16,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 12),
              child: Row(
                children: [
                  _buildTag(context, gender, isWide),
                  const SizedBox(width: 6),
                  _buildTag(context, category, isWide),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 16 : 12,
                vertical: 6,
              ),
              child: _buildStarRating(rating),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 16 : 12,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Text(
                    '\$${discountedPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isWide ? 18 : 16,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (product.discountPercent != null)
                    Text(
                      '\$${originalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 10 : 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isWide ? 13 : 12,
          color: Colors.pink,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    const totalStars = 5;
    final fullStars = rating.floor();
    final halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(totalStars, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, size: 16, color: Colors.amber);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 16, color: Colors.grey);
        }
      }),
    );
  }
}
