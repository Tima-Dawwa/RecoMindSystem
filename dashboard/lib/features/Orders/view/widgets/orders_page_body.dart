import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Orders/view/widgets/products_table.dart';
import 'package:dashboard/features/Orders/view/widgets/orders_search_bar.dart';
import 'package:flutter/material.dart';

class OrdersPageBody extends StatelessWidget {
  const OrdersPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    TextEditingController editingController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Orders archive",
                  style: TextStyle(
                    fontSize: 38,
                    color: Themes.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
                OrdersSearchBar(
                  controller: editingController,
                  searchQuery: "",
                  onChanged: (p0) {},
                  onClear: () {},
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Total orders statistics :",
              style: TextStyle(
                fontSize: 25,
                color: Themes.primary,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Orders number : 516,861,5",
                  style: TextStyle(fontSize: 22, color: Themes.text),
                ),
                SizedBox(height: 10),
                Text(
                  "Users ordered before : 5622",
                  style: TextStyle(fontSize: 22, color: Themes.text),
                ),
                SizedBox(height: 10),
                Text(
                  "Bills : \$626,655,646,8",
                  style: TextStyle(fontSize: 22, color: Themes.secondary),
                ),
              ],
            ),
            SizedBox(height: 20),
            ProductsTable(desktop: true, items: "50"),
          ],
        ),
      ),
    );
  }
}
