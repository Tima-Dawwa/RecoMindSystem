import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
        constraints: const BoxConstraints(maxWidth: 300),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.grey[500],
              size: 20,
            ),
            suffixIcon:
                searchQuery.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.grey[500],
                        size: 18,
                      ),
                      onPressed: onClear,
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
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
