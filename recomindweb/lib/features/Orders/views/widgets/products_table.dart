import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Orders/model/product_model.dart';
import 'package:recomindweb/features/Orders/views/widgets/row_content.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key, required this.desktop, required this.products});
  final bool desktop;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: DataTableTheme(
          data: DataTableThemeData(
            columnSpacing: desktop ? 30 : 20,
            dataRowHeight: desktop ? 100 : 85,
            headingRowHeight: desktop ? 50 : 40,
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
            source: RowContent(desktop: desktop, products: products),
            showFirstLastButtons: true,
            rowsPerPage: 3,
            header: Text(
              "${products.length} Products",
              style: TextStyle(fontSize: desktop ? 25 : 22, color: Themes.text),
            ),
            arrowHeadColor: Themes.primary,
            columns: [
              DataColumn(label: Text('Photo')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Pieces')),
              DataColumn(label: Text('Total')),
            ],
          ),
        ),
      ),
    );
  }
}
