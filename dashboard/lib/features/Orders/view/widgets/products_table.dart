import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Orders/view/widgets/row_content.dart';
import 'package:flutter/material.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key, required this.desktop, required this.items});
  final bool desktop;
  final String items;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: DataTableTheme(
          data: DataTableThemeData(
            columnSpacing: desktop ? 20 : 20,
            dataRowHeight: desktop ? 60 : 85,
            headingRowHeight: desktop ? 60 : 40,
            headingRowAlignment: MainAxisAlignment.center,
            // headingRowColor: WidgetStatePropertyAll(
            //   Themes.primary.withAlpha(50),
            // ),
            headingTextStyle: TextStyle(
              fontSize: desktop ? 20 : 18,
              color: Themes.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: PaginatedDataTable(
            source: RowContent(desktop: desktop),
            showFirstLastButtons: true,
            rowsPerPage: 5,
            // header: Text(
            //   "$items Products",
            //   style: TextStyle(fontSize: desktop ? 25 : 22, color: Themes.text),
            // ),
            arrowHeadColor: Themes.primary,
            columns: [
              DataColumn(label: Text('Usensme')),
              DataColumn(label: Text('Orders')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Items')),
              DataColumn(label: Text('Bill')),
            ],
          ),
        ),
      ),
    );
  }
}
