import 'package:flutter/material.dart';
import 'package:recomindweb/core/helpers/api.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
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
              child: Image.network(
                '${getIt.get<Api>().baseUrl}${products[index].image}',
                headers: {"ngrok-skip-browser-warning": "true"},
                width: desktop ? 90 : 75,
                height: desktop ? 90 : 75,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: desktop ? 90 : 75,
                      height: desktop ? 90 : 75,
                      decoration: BoxDecoration(
                        color: Themes.text.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: Themes.text.withAlpha(180),
                          size: 20,
                        ),
                      ),
                    ),
              ),
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
              '\$${products[index].price * products[index].quantity}',
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
