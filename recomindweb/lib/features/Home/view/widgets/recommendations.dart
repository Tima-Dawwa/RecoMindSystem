import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Home/model/collab_product_model.dart';
import 'package:recomindweb/features/Home/view%20model/cubit/home_cubit.dart';
import 'package:recomindweb/features/Home/view/widgets/home_product_card.dart';
import 'package:recomindweb/features/product_details/view/product_details_page.dart';

class Recommendations extends StatefulWidget {
  const Recommendations({super.key, required this.logged});
  final bool logged;

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  List<CollabProductModel> products = [];
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    products = BlocProvider.of<HomeCubit>(context).products;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          try {
            double cardWidth = constraints.maxWidth * 0.15;
            const double spacing = 15;
            int itemsPerRow =
                (constraints.maxWidth / (cardWidth + spacing)).floor();
            int itemCount =
                showAll
                    ? products.length
                    : itemsPerRow.clamp(1, products.length);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.logged ? 'For You' : 'Recommended',
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
                      index: index,
                      product: products[index],
                      logged: widget.logged,
                      onTap: () {
                        if (widget.logged) {
                          Get.to(
                            ProductDetailsPage(productId: products[index].id),
                          );
                        }
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
            );
          } catch (e) {
            return Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }
}
