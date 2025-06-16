import 'package:flutter/material.dart';

Color getTagColor(String? tagType) {
  switch (tagType?.toLowerCase()) {
    case 'trend':
      return Colors.orange.shade600;
    case 'new':
      return Colors.blue.shade600;
    case 'sale':
      return Colors.red.shade600;
    default:
      return Colors.grey.shade400;
  }
}
