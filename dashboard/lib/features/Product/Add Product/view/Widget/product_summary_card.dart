import 'package:flutter/material.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'card_wrapper.dart';

class ProductSummaryCard extends StatelessWidget {
  final int imageCount;
  final String? selectedCategory;
  final String? selectedGender;
  final String? selectedDepartment;
  final int colorCount;

  const ProductSummaryCard({
    super.key,
    required this.imageCount,
    required this.selectedCategory,
    required this.selectedGender,
    required this.selectedDepartment,
    required this.colorCount,
  });

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      title: 'Summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryRow(label: 'Images', value: '$imageCount uploaded'),
          SummaryRow(
            label: 'Category',
            value: selectedCategory ?? 'Not selected',
          ),
          SummaryRow(label: 'Gender', value: selectedGender ?? 'Not selected'),
          SummaryRow(
            label: 'Department',
            value: selectedDepartment ?? 'Not selected',
          ),
          SummaryRow(label: 'Colors', value: '$colorCount selected'),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const SummaryRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: Themes.text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
