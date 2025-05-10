import 'package:flutter/material.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/add_review_selection.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/color_selctor.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_attribute_card.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double originalPrice = 39.99;
    final double? discountedPrice = 29.99;
    final bool isDiscounted =
        discountedPrice != null && discountedPrice < originalPrice;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Relaxed Fit T-Shirt",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                "\$${discountedPrice?.toStringAsFixed(2) ?? originalPrice.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDiscounted ? Colors.redAccent : Colors.black,
                ),
              ),
              if (isDiscounted) ...[
                const SizedBox(width: 8),
                Text(
                  "\$${originalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ]
            ],
          ),

          const SizedBox(height: 16),

          Text(
            "Product Details",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 12),

          const Text(
            "Lorem ipsum flows with grace, "
            "Color dances, finds its place, "
            "In contrast, beauty shows its face.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              ProductAttributeCard(
                  label: "Graphic", value: "Decorated", icon: Icons.brush),
              ProductAttributeCard(
                  label: "Department", value: "Casual", icon: Icons.store),
              ProductAttributeCard(
                  label: "Fit", value: "Relaxed", icon: Icons.accessibility),
              ProductAttributeCard(
                  label: "Material", value: "100% Cotton", icon: Icons.texture),
            ],
          ),

          const SizedBox(height: 16),
          Divider(thickness: 1, color: Colors.grey),
          ColorSelector(),
          const SizedBox(height: 16),
          Divider(thickness: 1, color: Colors.grey[300]),
          const AddReviewSection()
        ],
      ),
    );
  }
}

/// Reusable product attribute display
class _ProductAttribute extends StatelessWidget {
  final String label;
  final String value;

  const _ProductAttribute({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
