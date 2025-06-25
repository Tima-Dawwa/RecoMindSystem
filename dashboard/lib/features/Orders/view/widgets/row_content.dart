import 'package:dashboard/core/utils/theme.dart';
import 'package:flutter/material.dart';

class RowContent extends DataTableSource {
  RowContent({required this.desktop});
  final bool desktop;

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
              '${index + 1}',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              'DD/MM/YYYY',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '\$${(index + 1) * (index + 1)}0',
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
  int get rowCount => 10;
  @override
  int get selectedRowCount => 0;
}
