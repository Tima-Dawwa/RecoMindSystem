import 'package:flutter/material.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';

class ColorSelectorMobile extends StatelessWidget {
  final Product product;

  const ColorSelectorMobile({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CircleAvatar(radius: 20, backgroundColor: _hexToColor(product.color))
                ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _hexToColor(String hex) {
  hex = hex.replaceAll("#", "");
  if (hex.length == 6) {
    hex = "FF$hex";
  }
  return Color(int.parse("0x$hex"));
}
