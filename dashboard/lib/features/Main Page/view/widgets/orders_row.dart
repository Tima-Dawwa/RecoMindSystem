import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/orders_model.dart';
import 'package:flutter/material.dart';

class OrdersRow extends DataTableSource {
  final List<OrdersModel> orders;

  OrdersRow({required this.orders});

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(
              orders[index].name,
              style: TextStyle(fontSize: 18, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              orders[index].orders.toString(),
              style: TextStyle(fontSize: 18, color: Themes.text),
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
