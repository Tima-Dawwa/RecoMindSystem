import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/widgets/content_all_products.dart';

class CustomTabBarView extends StatefulWidget {
  const CustomTabBarView({super.key});

  @override
  _CustomTabBarViewState createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<label> labels = [
    label(name: "All", urlImage1: "", urlImage2: ""),
    label(
      name: "Tops",
      urlImage1: "assets/Images/labels/tops1.png",
      urlImage2: "assets/Images/labels/top.png",
    ),
    label(name: "Bottoms", urlImage1: "", urlImage2: ""),
    label(name: "Jackets", urlImage1: "", urlImage2: ""),
    label(name: "Pyjama", urlImage1: "", urlImage2: ""),
    label(name: "Suits", urlImage1: "", urlImage2: ""),
    label(name: "Overall", urlImage1: "", urlImage2: ""),
    label(name: "Shoes", urlImage1: "", urlImage2: ""),
    label(name: "Bags", urlImage1: "", urlImage2: ""),
    label(name: "Hats", urlImage1: "", urlImage2: ""),
    label(name: "Accessory", urlImage1: "", urlImage2: ""),
    label(name: "Additions", urlImage1: "", urlImage2: ""),
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
                child:
                    isSelected
                        ? Image.asset("assets/Images/labels/tops1.png", width: 60)
                        : Image.asset("assets/Images/labels/clothes.png", width: 60),
                // Text(
                //   labels[index],
                //   style: TextStyle(
                //     color: isSelected ? Colors.white : Colors.black,
                //   ),
                // ),
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

class label {
  final String name;
  final String urlImage1;
  final String urlImage2;

  label({required this.name, required this.urlImage1, required this.urlImage2});
}
