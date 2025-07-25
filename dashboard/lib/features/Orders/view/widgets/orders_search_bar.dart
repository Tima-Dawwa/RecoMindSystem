import 'package:dashboard/core/utils/theme.dart';
import 'package:flutter/material.dart';

class OrdersSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const OrdersSearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search orders...',
            hintStyle: TextStyle(
              color: Themes.text.withAlpha(80),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Themes.text.withAlpha(80),
              size: 22,
            ),
            suffixIcon:
                searchQuery.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Themes.text.withAlpha(80),
                        size: 22,
                      ),
                      onPressed: onClear,
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Themes.text.withAlpha(15),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
