import 'package:flutter/material.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/color_option.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Color',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60, // fix height so color options don't grow infinitely
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ColorOption(color: Colors.black),
                  const SizedBox(width: 8),
                  ColorOption(color: Colors.grey),
                  const SizedBox(width: 8),
                  ColorOption(color: Colors.blue),
                  const SizedBox(width: 8),
                  ColorOption(color: Colors.yellow),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
