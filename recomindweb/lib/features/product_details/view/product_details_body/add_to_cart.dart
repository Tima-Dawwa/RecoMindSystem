import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/count_dialog.dart';

class AddToCart extends StatelessWidget {
  final Product product;

  const AddToCart({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (_) => ShowDialog(product: product),
        );

        if (result == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added to cart')),
          );
        }
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
