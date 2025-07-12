import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Orders/model/orders_model.dart';
import 'package:dashboard/features/Orders/view/widgets/row_content.dart';
import 'package:flutter/material.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key, required this.desktop, required this.orders});
  final bool desktop;
  final List<OrderModel> orders;

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
            headingRowColor: WidgetStatePropertyAll(
              Themes.primary.withAlpha(50),
            ),
            headingTextStyle: TextStyle(
              fontSize: desktop ? 20 : 18,
              color: Themes.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: PaginatedDataTable(
            source: RowContent(desktop: desktop, orders: orders),
            showFirstLastButtons: true,
            rowsPerPage: 4,
            header: Text(
              "Orders List",
              style: TextStyle(
                fontSize: desktop ? 25 : 22,
                color: Themes.text.withAlpha(200),
                fontWeight: FontWeight.bold,
              ),
            ),
            arrowHeadColor: Themes.primary,
            columns: [
              DataColumn(label: Text('Usensme')),
              DataColumn(label: Text('Status')),
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
