import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Orders/model/orders_model.dart';
import 'package:flutter/material.dart';

class RowContent extends DataTableSource {
  RowContent({
    required this.desktop,
    required this.orders,
    required this.context,
  });
  final bool desktop;
  final List<OrderModel> orders;
  final BuildContext context;
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(
              orders[index].name ?? 'Unknown',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // title: const Text('Warning !'),
                      content: const Text(
                        'Are you sure you want to mark this order as an "Delivered" ?',
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'back',
                            style: TextStyle(
                              color: Themes.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            'confirm',
                            style: TextStyle(
                              color: Themes.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                orders[index].status,
                style: TextStyle(
                  fontSize: desktop ? 18 : 16,
                  fontWeight:
                      orders[index].status == 'delivery'
                          ? FontWeight.normal
                          : FontWeight.bold,
                  color:
                      orders[index].status == 'delivery'
                          ? Themes.text
                          : Themes.secondary,
                ),
              ),
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
