import 'package:flutter/material.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/fliter_department.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/gird_all_products.dart';

class ContentAllProducts extends StatefulWidget {
  const ContentAllProducts({super.key, required this.type, required this.allProducts});
  final String type;
  final List<AllProductsModel> allProducts;

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
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterDepartment(price: price, categories: categories),
        GridAllProducts(price: price, type: widget.type , allProducts: widget.allProducts,),
      ],
    );
  }
}
