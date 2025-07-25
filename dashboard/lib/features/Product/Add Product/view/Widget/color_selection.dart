import 'package:flutter/material.dart';
import 'card_wrapper.dart';

class ColorSelectionWidget extends StatelessWidget {
  final List<String> selectedColors;
  final Function(List<String>) onColorsChanged;

  static const List<Map<String, dynamic>> _colors = [
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Pink', 'color': Colors.pink},
    {'name': 'Black', 'color': Colors.black},
    {'name': 'White', 'color': Colors.white},
    {'name': 'Grey', 'color': Colors.grey},
    {'name': 'Brown', 'color': Colors.brown},
    {'name': 'Navy', 'color': Colors.indigo},
  ];

  const ColorSelectionWidget({
    super.key,
    required this.selectedColors,
    required this.onColorsChanged,
  });

  void _toggleColor(String colorName) {
    List<String> newColors = List.from(selectedColors);
    if (newColors.contains(colorName)) {
      newColors.remove(colorName);
    } else {
      newColors.add(colorName);
    }
    onColorsChanged(newColors);
  }

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      title: 'Available Colors',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            _colors.map((colorData) {
              return ColorChip(
                colorData: colorData,
                isSelected: selectedColors.contains(colorData['name']),
                onToggle: () => _toggleColor(colorData['name']),
              );
            }).toList(),
      ),
    );
  }
}

class ColorChip extends StatelessWidget {
  final Map<String, dynamic> colorData;
  final bool isSelected;
  final VoidCallback onToggle;

  const ColorChip({
    super.key,
    required this.colorData,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(colorData['name']),
      selected: isSelected,
      onSelected: (selected) => onToggle(),
      backgroundColor: Colors.white,
      selectedColor: colorData['color'].withOpacity(0.2),
      checkmarkColor: colorData['color'],
      side: BorderSide(
        color: isSelected ? colorData['color'] : Colors.grey[300]!,
      ),
    );
  }
}
