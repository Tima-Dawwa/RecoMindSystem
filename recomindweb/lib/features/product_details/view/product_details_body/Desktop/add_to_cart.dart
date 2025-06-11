import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({super.key});

  @override
  Widget build(BuildContext context) {
    
    return OutlinedButton.icon(
      onPressed: () {
        // cubit.addToCart(productId: product.id, count: 3);
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