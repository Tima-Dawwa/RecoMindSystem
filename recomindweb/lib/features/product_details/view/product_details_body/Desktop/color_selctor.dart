import 'package:flutter/material.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';

class ColorSelector extends StatelessWidget {
  final Product product;
  const ColorSelector({super.key, required this.product});

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
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _hexToColor(product.color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String value) {

final Map<String, Color> colorMap = {
  // Direct Matches & Shades
  'Black': Colors.black,
  'Dark Blue': Colors.blue.shade900,
  'White': Colors.white,
  'Light Pink': Colors.pink.shade100,
  'Grey': Colors.grey,
  'Blue': Colors.blue,
  'Red': Colors.red,
  'Light Blue': Colors.lightBlue,
  'Dark Grey': Colors.grey.shade800,
  'Dark Red': Colors.red.shade900,
  'Dark Green': Colors.green.shade900,
  'Light Grey': Colors.grey.shade300,
  'Pink': Colors.pink,
  'Yellow': Colors.yellow,
  'Light Orange': Colors.orange.shade200,
  'Dark Orange': Colors.deepOrange.shade700,
  'Dark Pink': Colors.pink.shade700,
  'Green': Colors.green,
  'Orange': Colors.orange,
  'Light Green': Colors.lightGreen,
  'Dark Yellow': Colors.amber.shade800,
  'Light Purple': Colors.purple.shade200,
  'Dark Turquoise': Colors.teal.shade700,
  'Turquoise': Colors.teal,
  'Dark Purple': Colors.deepPurple,
  'Light Red': Colors.red.shade200,
  'Purple': Colors.purple,

  // Custom Colors (Not in Material Palette)
  'Light Beige': const Color(0xFFF5F5DC),
  'Greenish Khaki': const Color(0xFFBDB76B),
  'Off White': const Color(0xFFFAF9F6),
  'Beige': const Color(0xFFF5F5DC),
  'Yellowish Brown': Colors.brown.shade300,
  'Gold': const Color(0xFFFFD700),
  'Dark Beige': const Color(0xFF9F8C76),
  'Light Turquoise': Colors.cyan.shade200,
  'Light Yellow': Colors.yellow.shade200,
  'Silver': const Color(0xFFC0C0C0),
  'Greyish Beige': const Color(0xFFC8BBAE),
  'Bronze/Copper': const Color(0xFFCD7F32),

  // Mappings for "Other" categories
  'Other Pink': Colors.pink,
  'Other Yellow': Colors.yellow,
  'Other Orange': Colors.orange,
  'Other Green': Colors.green,
  'Other Red': Colors.red,
  'Other Blue': Colors.blue,
  'Other Purple': Colors.purple,
  'Other Turquoise': Colors.teal,

  // Unmapped/Transparent categories
  'Other': Colors.transparent,
  'Transparent': Colors.transparent,
  'Unknown': Colors.transparent,
};


    if (colorMap.containsKey(value)) return colorMap[value]!;

    try {
      var hex = value.replaceAll("#", "");
      if (hex.length == 6) hex = "FF$hex";
      return Color(int.parse("0x$hex"));
    } catch (_) {
      return Colors.black;
    }
  }

}
