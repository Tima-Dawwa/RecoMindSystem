import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Widget/widget_badge.dart';
import 'package:flutter/material.dart';
import 'rating_stars.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final VoidCallback onTap; // Single tap for details
  final VoidCallback onDoubleTap; // Double tap for selection

  const ProductCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap, // Single tap for details
          onDoubleTap: onDoubleTap, // Double tap for selection
          splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
          child: Container(
            decoration: BoxDecoration(
              border:
                  isSelected
                      ? Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      )
                      : Border.all(color: Colors.grey.shade200, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FIXED: Enhanced image container with proper constraints
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    color: Colors.grey[50],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.asset(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Image not found',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (product.status != 'normal')
                        Positioned(
                          top: 12,
                          left: 12,
                          child: StatusBadge(status: product.status),
                        ),
                      if (isSelected)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      if (!isSelected)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.touch_app_outlined,
                              color: Colors.white.withOpacity(0.8),
                              size: 16,
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Qty: ${product.amount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF1A202C),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                RatingStars(rating: product.rating, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  product.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF718096),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${product.amount} left',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Tap: Details • Double-tap: Select',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
