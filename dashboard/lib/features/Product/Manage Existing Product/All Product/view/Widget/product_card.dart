import 'package:dashboard/core/utils/constant.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/Model/all_product_model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/selected_card.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/All%20Product/view/Widget/widget_badge.dart';
import 'package:flutter/material.dart';
import 'rating_stars.dart';

class ProductCard extends StatelessWidget {
  final AllProductModel product;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final bool isCompactView;

  const ProductCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
    this.isCompactView = false,
  });

  @override
  Widget build(BuildContext context) {
    final status =
        product.isTrend ? 'trending' : (product.isNew ? 'new' : 'normal');
    final amount = product.quantity;
    final imageUrl = ngrok + product.image;


    if (isCompactView) {
      return _buildCompactCard(context, status, amount, imageUrl);
    } else {
      return _buildGridCard(context, status, amount, imageUrl);
    }
  }

  Widget _buildCompactCard(
    BuildContext context,
    String status,
    int amount,
    String imageUrl,
  ) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onDoubleTap: onDoubleTap,
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Image section
                Container(
                  width: 120,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                    color: Colors.grey[50],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(11),
                          ),
                          child: Image.network(
                            imageUrl,
                            headers: {"ngrok-skip-browser-warning": "true"},
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(11),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 24,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'No image',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (status != 'normal')
                        Positioned(
                          top: 8,
                          left: 8,
                          child: StatusBadge(status: status),
                        ),
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Content section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product name and price in same row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF1A202C),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        // Fixed: Changed from discountPrice to isDiscounted
                                        color:
                                            product.isDiscounted
                                                ? Colors.grey[500]
                                                : Theme.of(
                                                  context,
                                                ).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            product.isDiscounted ? 11 : 14,
                                        decoration:
                                            product.isDiscounted
                                                ? TextDecoration.lineThrough
                                                : null,
                                      ),
                                    ),
                                    // Fixed: Check isDiscounted and use discountedPrice
                                    if (product.isDiscounted) ...[
                                      const SizedBox(width: 4),
                                      Text(
                                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Rating and category in same row
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  RatingStars(
                                    // Fixed: Changed from averageRating to rating
                                    rating: product.rating,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF718096),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      // Fixed: Changed from category to department
                                      product.department,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Qty: $amount',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
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

  Widget _buildGridCard(
    BuildContext context,
    String status,
    int amount,
    String imageUrl,
  ) {
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
          onTap: onTap,
          onDoubleTap: onDoubleTap,
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
                          child: Image.network(
                            imageUrl,
                            headers: {"ngrok-skip-browser-warning": "true"},

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
                      if (status != 'normal')
                        Positioned(
                          top: 12,
                          left: 12,
                          child: StatusBadge(status: status),
                        ),
                      if (isSelected) SelectedCard(),
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
                            'Qty: $amount',
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
                        // Product name and price in same row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
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
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        // Fixed: Changed from discountPrice to isDiscounted
                                        color:
                                            product.isDiscounted
                                                ? Colors.grey[500]
                                                : Theme.of(
                                                  context,
                                                ).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            product.isDiscounted ? 12 : 16,
                                        decoration:
                                            product.isDiscounted
                                                ? TextDecoration.lineThrough
                                                : null,
                                      ),
                                    ),
                                    // Fixed: Check isDiscounted and use discountedPrice
                                    if (product.isDiscounted) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Rating and category in same row
                        Row(
                          children: [
                            RatingStars(
                              // Fixed: Changed from averageRating to rating
                              rating: product.rating,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF718096),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
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
                                // Fixed: Changed from category to department
                                product.department,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Fixed: Removed empty container that was causing issues
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
