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
    label(
      name: "All",
      urlImage1: "assets/Images/labels/all1.jpg",
      urlImage2: "assets/Images/labels/all.jpg",
    ),
    label(
      name: "Tops",
      urlImage1: "assets/Images/labels/top1.jpg",
      urlImage2: "assets/Images/labels/top.jpg",
    ),
    label(
      name: "Bottoms",
      urlImage1: "assets/Images/labels/bottom1.jpg",
      urlImage2: "assets/Images/labels/bottom.jpg",
    ),
    label(
      name: "Jackets",
      urlImage1: "assets/Images/labels/jacket1.jpg",
      urlImage2: "assets/Images/labels/jacket.jpg",
    ),
    label(
      name: "Pyjama",
      urlImage1: "assets/Images/labels/pyjama1.jpg",
      urlImage2: "assets/Images/labels/pyjama.jpg",
    ),
    label(
      name: "Suits",
      urlImage1: "assets/Images/labels/suits1.jpg",
      urlImage2: "assets/Images/labels/suits.jpg",
    ),
    label(
      name: "Overall",
      urlImage1: "assets/Images/labels/overall1.jpg",
      urlImage2: "assets/Images/labels/overall.jpg",
    ),
    label(
      name: "Shoes",
      urlImage1: "assets/Images/labels/shoes1.jpg",
      urlImage2: "assets/Images/labels/shoes.jpg",
    ),
    label(
      name: "Bags",
      urlImage1: "assets/Images/labels/bag1.jpg",
      urlImage2: "assets/Images/labels/bags.jpg",
    ),
    label(
      name: "Hats",
      urlImage1: "assets/Images/labels/hat1.jpg",
      urlImage2: "assets/Images/labels/hat.jpg",
    ),
    label(
      name: "Accessory",
      urlImage1: "assets/Images/labels/accessory1.jpg",
      urlImage2: "assets/Images/labels/accessory.jpg",
    ),
    label(
      name: "Additions",
      urlImage1: "assets/Images/labels/additions1.jpg",
      urlImage2: "assets/Images/labels/additions.jpg",
    ),
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
          spacing: 15,
          runSpacing: 8,
          children: List.generate(labels.length, (index) {
            final isSelected = _tabController.index == index;
            return GestureDetector(
              onTap: () {
                _tabController.animateTo(index);
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Themes.primary : Themes.bg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child:
                    isSelected
                        ? Image.asset(labels[index].urlImage1, width: 80)
                        : Image.asset(labels[index].urlImage2, width: 80),
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
