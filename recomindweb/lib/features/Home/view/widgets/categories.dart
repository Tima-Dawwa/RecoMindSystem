import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/features/Home/view/widgets/category_card.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, required this.desktop});
  final bool desktop;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width =
            desktop
                ? constraints.maxWidth * 0.312
                : constraints.maxWidth * 0.30;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryCard(photo: "assets/Images/women.jpg", width: width),
                  CategoryCard(photo: "assets/Images/men.jpg", width: width),
                  CategoryCard(photo: "assets/Images/kids.jpg", width: width),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: "WOMEN",
                    height: desktop ? 40 : 25,
                    size: desktop ? 20 : 12,
                    width: width,
                    press: () {
                      context.go('/all-products');
                    },
                  ),
                  CustomButton(
                    text: "MEN",
                    height: desktop ? 40 : 25,
                    size: desktop ? 20 : 12,
                    width: width,
                    press: () {
                      context.go('/all-products');
                    },
                  ),
                  CustomButton(
                    text: "KIDS",
                    height: desktop ? 40 : 25,
                    size: desktop ? 20 : 12,
                    width: width,
                    press: () {
                      context.go('/all-products');
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
