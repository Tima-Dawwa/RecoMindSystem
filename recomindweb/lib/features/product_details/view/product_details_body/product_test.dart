import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/recommedation_product.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_cubit.dart';

class ProductCard extends StatefulWidget {
  final Recommendation product;
  final VoidCallback onTap;

  const ProductCard({required this.product, required this.onTap, super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final productDetailsCubit = context.read<ProductDetailsCubit>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return _ResponsiveProductCard(
          product: widget.product,
          isWide: isWide,
          onTap: widget.onTap,
          isFavorite: widget.product.isfavorite,
          onFavoriteToggle: () {
            setState(() {
              if (widget.product.isfavorite) {
                productDetailsCubit.deleteFavorite(widget.product.id,widget.product.parentId);
              } else {
                productDetailsCubit.addToFavorites(widget.product.id,
                  widget.product.parentId,
                );
              }
            });
          },
        );
      },
    );
  }
}

class _ResponsiveProductCard extends StatelessWidget {
  final Recommendation product;
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
          color: Themes.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Themes.text.withAlpha(40)),
          boxShadow: [
            BoxShadow(
              color: Themes.text.withAlpha(50),
              blurRadius: 2,
              offset: const Offset(0, 2),
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
                      product.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (product.isTrend)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Themes.secondary.withAlpha(200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "TREND",
                          style: TextStyle(
                            fontSize: 12,
                            color: Themes.bg,
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
                        decoration: BoxDecoration(
                          color: Themes.bg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                         product.isfavorite ? Icons.favorite : Icons.favorite_border,
                          color:
                              isFavorite
                                  ? Themes.secondary
                                  : Themes.text.withAlpha(150),
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
                  color: Themes.text,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 12),
              child: Row(
                children: [
                  _buildTag(context, product.gender, isWide),
                  const SizedBox(width: 6),
                  _buildTag(context, product.department, isWide),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 16 : 12,
                vertical: 6,
              ),
              child: _buildStarRating(product.rating),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 16 : 12,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Text(
                    '\$${product.discountedPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isWide ? 18 : 16,
                      color: Themes.secondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (product.isDiscounted)
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                        color: Themes.text.withAlpha(150),
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
        color: Themes.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isWide ? 13 : 12,
          color: Themes.primary,
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
          return Icon(
            Icons.star_border,
            size: 16,
            color: Themes.text.withAlpha(150),
          );
        }
      }),
    );
  }
}
