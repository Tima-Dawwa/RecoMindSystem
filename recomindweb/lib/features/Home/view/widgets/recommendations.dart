import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:recomindweb/features/Home/view/widgets/home_product_card.dart';

class Recommendations extends StatefulWidget {
  const Recommendations({super.key});

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  final List<Product> products = List.generate(
    20,
    (index) => Product(
      name: "Product A",
      imageUrl: "assets/Images/main_side.png",
      price: 29.99,
      discountPercent: 25,
      isFavorite: false,
      gender: "Female",
      category: "Ladieswear",
      isTrending: true,
      rating: 4.5,
      tagType: "Trend",
    ),
  );
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = constraints.maxWidth * 0.15;
          const double spacing = 15;
          int itemsPerRow =
              (constraints.maxWidth / (cardWidth + spacing)).floor();
          int itemCount =
              showAll ? products.length : itemsPerRow.clamp(1, products.length);
          return Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "For you",
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: itemsPerRow,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent: MediaQuery.of(context).size.width * 0.24,
                  ),
                  itemBuilder: (context, index) {
                    return HomeProductCard(
                      width: cardWidth,
                      product: products[index],
                      onTap: () {
                         context.go('/product-details');
                      },
                    );
                  },
                ),
                if (!showAll)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Show more",
                            style: TextStyle(color: Themes.text, fontSize: 18),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.arrow_downward_rounded,
                              color: Themes.text,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                showAll = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                if (showAll)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Show less",
                            style: TextStyle(color: Themes.text, fontSize: 18),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.arrow_upward_rounded,
                              color: Themes.text,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                showAll = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
