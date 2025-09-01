import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Orders/model/orders_model.dart';
import 'package:dashboard/features/Orders/model/orders_statistics.dart';
import 'package:dashboard/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:dashboard/features/Orders/view/widgets/products_table.dart';
import 'package:dashboard/features/Orders/view/widgets/orders_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrdersPageBody extends StatefulWidget {
  const OrdersPageBody({super.key});

  @override
  State<OrdersPageBody> createState() => _OrdersPageBodyState();
}

class _OrdersPageBodyState extends State<OrdersPageBody> {
  List<OrderModel> orders = [];
  OrdersStatistics? orderDetails;

  @override
  void initState() {
    super.initState();
    orders = BlocProvider.of<OrdersCubit>(context).orders;
    orderDetails = BlocProvider.of<OrdersCubit>(context).orderDetails;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    TextEditingController editingController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(18),
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Orders archive",
                    style: TextStyle(
                      fontSize: 38,
                      color: Themes.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 25),
                  OrdersSearchBar(
                    controller: editingController,
                    searchQuery: "",
                    onChanged: (str) {},
                    onClear: () {},
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      Themes.customDatePicker(context: context);
                    },
                    icon: Icon(
                      Icons.calendar_today,
                      color: Themes.primary,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Total orders statistics :",
                style: TextStyle(
                  fontSize: 25,
                  color: Themes.text.withAlpha(150),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10),
            if (orderDetails != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.archive, size: 25, color: Themes.text),
                    SizedBox(width: 6),
                    Text(
                      "Orders count ${orderDetails!.orders}",
                      style: TextStyle(fontSize: 22, color: Themes.text),
                    ),
                    Spacer(flex: 1),
                    Icon(Icons.person, size: 25, color: Themes.text),
                    SizedBox(width: 6),
                    Text(
                      "Users ordered before ${orderDetails!.users}",
                      style: TextStyle(fontSize: 22, color: Themes.text),
                    ),
                    Spacer(flex: 1),
                    Icon(
                      FontAwesomeIcons.sackDollar,
                      size: 22,
                      color: Themes.secondary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Profits \$${orderDetails!.profits}",
                      style: TextStyle(fontSize: 22, color: Themes.secondary),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            if (orders.isNotEmpty) ProductsTable(desktop: true, orders: orders),
            if (orders.isEmpty)
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3,
                ),
                child: Center(
                  child: Text(
                    "No orders yet",
                    style: TextStyle(
                      fontSize: 30,
                      color: Themes.text.withAlpha(100),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
