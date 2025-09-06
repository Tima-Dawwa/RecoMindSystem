import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_cubit.dart';

// ignore: must_be_immutable
class FilterDepartment extends StatefulWidget {
  FilterDepartment({
    super.key,
    required this.categories,
    required this.currentPage,
    required this.type, required this.gender,
  });

  List<String> categories;
  final int currentPage;
  final String type;
final String gender;

  @override
  State<FilterDepartment> createState() => _FilterDepartmentState();
}

class _FilterDepartmentState extends State<FilterDepartment> {
  final List<String> selectedCategories = [];
  var rangeValues = RangeValues(0, 1000);

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
            const SizedBox(height: 20),
            const Text("Price :", style: TextStyle(fontSize: 18)),
            // SliderFilter(rangeValues: RangeValues(0, 100000))
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    valueIndicatorTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    valueIndicatorColor: Themes.primary,
                    showValueIndicator: ShowValueIndicator.always,
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                  ),
                  child: RangeSlider(
                    values: rangeValues,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    labels: RangeLabels(
                      "\$${rangeValues.start.round()}",
                      "\$${rangeValues.end.round()}",
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        rangeValues = values;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$0", style: TextStyle(color: Colors.grey[600])),

                    Text("\$1000", style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                Padding(padding: const EdgeInsets.only(right: 16)),
                Text(
                  "\$${rangeValues.start.round()} - \$${rangeValues.end.round()}",
                  style: TextStyle(
                    color: Themes.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: () {
                    setState(() {
                      selectedCategories.clear();
                      rangeValues = RangeValues(0, 1000);
                    });
                  },
                  child: Text("Reset", style: TextStyle(color: Themes.primary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Themes.primary,
                  ),
                  onPressed: getAll,
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

  void getAll() {
    BlocProvider.of<AllProductsCubit>(context).getAllProducts(
      page: widget.currentPage + 1,
      type: widget.type,
      minPrice: rangeValues.start,
      maxPrice: rangeValues.end,
      categories: selectedCategories,
      isNew: selectedCategories.contains("New"),
      isTrend: selectedCategories.contains("Trend"),
      gender: widget.gender
    );
    BlocProvider.of<AllProductsCubit>(context).applyFilter();
  }
}
