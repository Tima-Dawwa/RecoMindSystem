import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/orders_model.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/orders_row.dart';
import 'package:flutter/material.dart';

class OrdersTable extends StatelessWidget {
  const OrdersTable({super.key, required this.orders});
  final List<OrdersModel> orders;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.37,
      child: DataTableTheme(
        data: DataTableThemeData(
          columnSpacing: 20,
          dataRowHeight: 60,
          headingRowHeight: 60,
          headingRowAlignment: MainAxisAlignment.center,
          headingRowColor: WidgetStatePropertyAll(Themes.primary.withAlpha(50)),
          headingTextStyle: TextStyle(
            fontSize: 20,
            color: Themes.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: PaginatedDataTable(
          source: OrdersRow(orders: orders),
          rowsPerPage: 5,
          header: Text(
            "Top Customers By Orders",
            style: TextStyle(
              fontSize: 25,
              color: Themes.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          arrowHeadColor: Themes.primary,
          columns: [
            DataColumn(label: Text('Customer Name')),
            DataColumn(label: Text('Orders Count')),
          ],
        ),
      ),
    );
  }
}
