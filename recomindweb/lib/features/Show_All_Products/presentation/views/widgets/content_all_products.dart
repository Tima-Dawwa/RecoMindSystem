import 'package:flutter/material.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/widgets/fliter_department.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/widgets/gird_all_products.dart';

class ContentAllProducts extends StatefulWidget {
  const ContentAllProducts({super.key});

  @override
  State<ContentAllProducts> createState() => _ContentAllProductsState();
}

class _ContentAllProductsState extends State<ContentAllProducts> {
  double price = 500;
  final List<String> categories = [
    "Electronics",
    "Clothes",
    "Books",
    "Toys",
    "Food",
    "Electronics",
    "Clothes",
    "Books",
    "Toys",
    "Food",
    "Electronics",
    "Clothes",
    "Books",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterDepartment(price: price, categories: categories,),
        GridAllProducts(price: price,),
      ],
    );
  }
}



