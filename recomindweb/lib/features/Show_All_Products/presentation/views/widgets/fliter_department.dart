import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/widgets/slider_filter.dart';

// ignore: must_be_immutable
class FilterDepartment extends StatefulWidget {
  FilterDepartment({super.key, required this.price, required this.categories});

  late double price;
  List<String> categories;

  @override
  State<FilterDepartment> createState() => _FilterDepartmentState();
}

class _FilterDepartmentState extends State<FilterDepartment> {
  final List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Filters",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(height: 8),
            const Text("Price :", style: TextStyle(fontSize: 18)),
            SliderFilter(rangeValues: RangeValues(100, 100000)),
            const SizedBox(height: 20),
            const Text(" Category :", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children:
                  widget.categories.map((cat) {
                    final isSelected = selectedCategories.contains(cat);
                    return FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(cat);
                          } else {
                            selectedCategories.remove(cat);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: () {
                    setState(() {
                      widget.price = 500;
                      selectedCategories.clear();
                    });
                  },
                  child: Text("Reset", style: TextStyle(color: Themes.primary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Themes.primary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "فلترة بسعر ${widget.price} وأنواع: ${selectedCategories.join(', ')}",
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
