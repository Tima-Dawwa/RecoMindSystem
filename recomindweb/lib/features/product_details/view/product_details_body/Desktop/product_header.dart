import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_cubit.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/add_to_cart.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/color_selctor.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/Desktop/price.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/product_attribute_card.dart';

class ProductHeader extends StatelessWidget {
  final Product product;
  const ProductHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productDetailsCubit = context.read<ProductDetailsCubit>();

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
                    SizedBox(width: double.infinity, child: AddToCart()),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Price(product: product),
                    AddToCart(),
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
                label: "Departmen",
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

//   Widget _addToCartButton(
//     BuildContext context,
//     ProductDetailsCubit cubit,
//     Product product,
//   ) {
//     return OutlinedButton.icon(
//       onPressed: () {
//         // cubit.addToCart(productId: product.id, count: 3);
//       },
//       icon: const Icon(Icons.add_shopping_cart_outlined, size: 18),
//       label: const Text("Add to Cart"),
//       style: OutlinedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         foregroundColor: Themes.secondary,
//         side: BorderSide(color: Themes.secondary),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
// }

  // Widget _priceWidget(
  //   bool isDiscounted,
  //   double? discountedPrice,
  //   double originalPrice,
  // ) {
  //   final displayPrice = isDiscounted ? discountedPrice! : originalPrice;

  //   return Row(
  //     children: [
  //       Text(
  //         "\$${displayPrice.toStringAsFixed(2)}",
  //         style: TextStyle(
  //           fontSize: 22,
  //           fontWeight: FontWeight.bold,
  //           color: isDiscounted ? Themes.secondary : Themes.primary,
  //         ),
  //       ),
  //       if (isDiscounted) ...[
  //         const SizedBox(width: 8),
  //         Text(
  //           "\$${originalPrice.toStringAsFixed(2)}",
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: Themes.text.withAlpha(120),
  //             decoration: TextDecoration.lineThrough,
  //           ),
  //         ),
  //         const SizedBox(width: 6),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //           decoration: BoxDecoration(
  //             color: Themes.secondary.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(4),
  //           ),
  //           child: Text(
  //             "-${_calculateDiscountPercent(originalPrice, discountedPrice!)}%",
  //             style: TextStyle(
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //               color: Themes.secondary,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ],
  //   );
  // }

  // int _calculateDiscountPercent(double original, double discounted) {
  //   return (((original - discounted) / original) * 100).round();
  // }

 
