import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/color_selctor.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_attribute_card.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double originalPrice = 39.99;
    final double discountedPrice = 29.99;
    final bool isDiscounted = discountedPrice < originalPrice;

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
              color: Themes.text,
            ),
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 350;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _priceWidget(isDiscounted, discountedPrice, originalPrice),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: _addToCartButton(context),
                    ),
                  ],
                );
              } else {
                // Horizontal layout for wider screens
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _priceWidget(isDiscounted, discountedPrice, originalPrice),
                    _addToCartButton(context),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 20),

          Text(
            "Product Details",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Themes.text.withAlpha(180),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            "Lorem ipsum flows with grace, "
            "Color dances, finds its place, "
            "In contrast, beauty shows its face.",
            style: TextStyle(fontSize: 16, height: 1.6, color: Themes.text),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              ProductAttributeCard(
                label: "Graphic",
                value: "Decorated",
                icon: Icons.brush,
              ),
              ProductAttributeCard(
                label: "Department",
                value: "Casual",
                icon: Icons.store,
              ),
              ProductAttributeCard(
                label: "Fit",
                value: "Relaxed",
                icon: Icons.accessibility,
              ),
              ProductAttributeCard(
                label: "Material",
                value: "100% Cotton",
                icon: Icons.texture,
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(thickness: 1, color: Themes.text.withAlpha(20)),
          const SizedBox(height: 16),

          const ColorSelector(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _priceWidget(
    bool isDiscounted,
    double? discountedPrice,
    double originalPrice,
  ) {
    return Row(
      children: [
        Text(
          "\$${discountedPrice?.toStringAsFixed(2) ?? originalPrice.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color:
                isDiscounted ? Themes.secondary : Themes.primary.withAlpha(200),
          ),
        ),
        if (isDiscounted) ...[
          const SizedBox(width: 8),
          Text(
            "\$${originalPrice.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              color: Themes.text.withAlpha(150),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Widget _addToCartButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added to cart !"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Themes.primary.withAlpha(200),
          ),
        );
      },
      icon: const Icon(Icons.add_shopping_cart_outlined, size: 18),
      label: const Text("Add to Cart"),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        foregroundColor: Themes.secondary,
        side: BorderSide(color: Themes.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
