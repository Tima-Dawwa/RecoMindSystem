import 'package:flutter/widgets.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';

class Price extends StatelessWidget {
  final Product product;

  const Price({
    super.key,
    required this.product,

  });
  int _calculateDiscountPercent(double original, double discounted) {
    return (((original - discounted) / original) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final displayPrice = product.isDiscounted ? product.discountedPrice : product.price;

    return Row(
      children: [
        Text(
          "\$${displayPrice.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: product.isDiscounted ? Themes.secondary : Themes.primary,
          ),
        ),
        if (product.isDiscounted) ...[
          const SizedBox(width: 8),
          Text(
            "\$${product.price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              color: Themes.text.withAlpha(120),
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Themes.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "-${_calculateDiscountPercent(product.price, product.discountedPrice)}%",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Themes.secondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
