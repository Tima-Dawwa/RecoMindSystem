import 'package:flutter/material.dart';
import 'package:recomindweb/features/product_details/view/product_details_body/color_option.dart';

class ColorSelectorMobile extends StatelessWidget {
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
                ColorOption(color: Colors.black),
                SizedBox(width: 8),
                ColorOption(color: Colors.grey),
                SizedBox(width: 8),
                ColorOption(color: Colors.blue),
                SizedBox(width: 8),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
