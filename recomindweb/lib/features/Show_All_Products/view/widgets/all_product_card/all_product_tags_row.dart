import 'package:flutter/material.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';

class AllProductTagsRow extends StatelessWidget {
  final AllProductsModel product;

  const AllProductTagsRow({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildTag(product.gender, Colors.purple),
        const SizedBox(width: 6),
        _buildTag(product.department, Colors.purple),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
