import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Orders/model/orders_model.dart';
import 'package:flutter/material.dart';

class RowContent extends DataTableSource {
  RowContent({required this.desktop, required this.orders});
  final bool desktop;
  final List<OrderModel> orders;

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(
              'User ${index + 1}',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              orders[index].status,
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              orders[index].date.substring(0, 10),
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${orders[index].productsCount}',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '\$${orders[index].totalPrice}',
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
  int get rowCount => orders.length;
  @override
  int get selectedRowCount => 0;
}
