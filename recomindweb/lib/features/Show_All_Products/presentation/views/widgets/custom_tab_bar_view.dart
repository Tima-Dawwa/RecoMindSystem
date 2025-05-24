import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/widgets/content_all_products.dart';

class CustomTabBarView extends StatefulWidget {
  const CustomTabBarView({super.key});

  @override
  _CustomTabBarViewState createState() =>
      _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> labels = [
    "Flutter",
    "Tabbar",
    "Tabbarview",
    "Tutorial",
    "Flutterdev",
    "Flutter",
    "Tabbar",
    "Tabbarview",
    "Tutorial",
    "Flutterdev",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: labels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(labels.length, (index) {
            final isSelected = _tabController.index == index;
            return GestureDetector(
              onTap: () {
                _tabController.animateTo(index);
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Themes.primary : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children:
                labels.map((label) {
                  return ContentAllProducts();
                }).toList(),
          ),
        ),
      ],
    );
  }
}



