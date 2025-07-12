import 'package:flutter/material.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Orders/model/product_model.dart';

class RowContent extends DataTableSource {
  RowContent({required this.desktop, required this.products});
  final bool desktop;
  final List<ProductModel> products;
  Api? api;
  
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Text(''),
              // Image.network(
              //   "${api!.baseUrl}${products[index].image}",
              //   width: desktop ? 90 : 75,
              //   height: desktop ? 90 : 75,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              products[index].name,
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              products[index].category,
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '\$${products[index].price.toString()}',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              products[index].quantity.toString(),
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '\$${products[index].price* products[index].quantity}',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => products.length;
  @override
  int get selectedRowCount => 0;
}
