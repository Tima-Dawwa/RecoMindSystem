import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Orders/model/orders_model.dart';
import 'package:dashboard/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                if (orders[index].status == 'prepare') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Themes.bg,
                        elevation: 2,
                        title: Text(
                          'Warning !',
                          style: TextStyle(
                            fontSize: 25,
                            color: Themes.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to mark\nthis order as a "Delivered" ?',
                          style: TextStyle(fontSize: 20, color: Themes.text),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        // actionsPadding: EdgeInsets.all(50),
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.all(10),
                            color: Themes.text,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            splashColor: Themes.bg.withAlpha(10),
                            child: Text(
                              'Back',
                              style: TextStyle(color: Themes.bg, fontSize: 18),
                            ),
                          ),
                          SizedBox(width: 15),
                          MaterialButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await BlocProvider.of<OrdersCubit>(
                                context,
                              ).changeStatus(id: orders[index].id);
                            },
                            color: Themes.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            padding: EdgeInsets.all(10),
                            splashColor: Themes.bg.withAlpha(10),
                            child: Text(
                              'Confirm',
                              style: TextStyle(color: Themes.bg, fontSize: 18),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
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
