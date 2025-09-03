import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/interactions_model.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/interactions_row.dart';
import 'package:flutter/material.dart';

class InteractionsTable extends StatelessWidget {
  const InteractionsTable({super.key, required this.interactions});
  final List<InteractionsModel> interactions;

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
          source: InteractionsRow(interactions: interactions),
          rowsPerPage: 5,
          header: Text(
            "Top Customers By Interactions",
            style: TextStyle(
              fontSize: 25,
              color: Themes.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          arrowHeadColor: Themes.primary,
          columns: [
            DataColumn(label: Text('Customer Name')),
            DataColumn(label: Text('Interactions Count')),
          ],
        ),
      ),
    );
  }
}
