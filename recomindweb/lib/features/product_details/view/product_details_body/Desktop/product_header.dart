import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/add_to_cart.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/color_selctor.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/price.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_attribute_card.dart';

class ProductHeader extends StatelessWidget {
  final Product product;
  const ProductHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
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
                    Price(product: product),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: AddToCart(product: product),
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Price(product: product),
                    AddToCart(product: product),
                    // _addToCartButton(context, productDetailsCubit, product),
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
            product.details,
            style: TextStyle(fontSize: 16, height: 1.6, color: Themes.text),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ProductAttributeCard(
                label: "Graphic",
                value: product.graphic,
                icon: Icons.brush,
              ),
              ProductAttributeCard(
                label: "Department",
                value: product.department,
                icon: Icons.store,
              ),
              ProductAttributeCard(
                label: "Gender",
                value: product.gender,
                icon: FontAwesomeIcons.six,
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(thickness: 1, color: Themes.text.withAlpha(20)),
          const SizedBox(height: 16),
          ColorSelector(product: product),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
