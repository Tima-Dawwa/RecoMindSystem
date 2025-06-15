import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class RowContent extends DataTableSource {
  RowContent({required this.desktop});
  final bool desktop;

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/Images/main_side.png",
                width: desktop ? 90 : 75,
                height: desktop ? 90 : 75,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              'Name${index + 1}',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              'Category${index + 1}',
              style: TextStyle(fontSize: desktop ? 18 : 16, color: Themes.text),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              '\$${index + 1}0',
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
