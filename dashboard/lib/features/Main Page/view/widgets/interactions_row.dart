import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/interactions_model.dart';
import 'package:flutter/material.dart';

class InteractionsRow extends DataTableSource {
  final List<InteractionsModel> interactions;

  InteractionsRow({required this.interactions});
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Text(
              interactions[index].name,
              style: TextStyle(fontSize: 18, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              interactions[index].interactions.toString(),
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
  int get rowCount => interactions.length;
  @override
  int get selectedRowCount => 0;
}
