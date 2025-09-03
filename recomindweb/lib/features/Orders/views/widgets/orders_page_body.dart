import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Orders/model/orders_model.dart';
import 'package:recomindweb/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:recomindweb/features/Orders/views/widgets/filters.dart';
import 'package:recomindweb/features/Orders/views/widgets/order_card.dart';

class OrdersPageBody extends StatefulWidget {
  const OrdersPageBody({super.key, required this.desktop});
  final bool desktop;

  @override
  State<OrdersPageBody> createState() => _OrdersPageBodyState();
}

class _OrdersPageBodyState extends State<OrdersPageBody> {
  List<OrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    orders = BlocProvider.of<OrdersCubit>(context).orders;

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Filters(orders: orders),
          Divider(thickness: 1, color: Themes.text.withAlpha(50)),
          if (widget.desktop)
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 265,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderCard(
                    id: orders[index].id,
                    state: orders[index].status,
                    date: orders[index].date,
                    orderNum: orders[index].orderNum.toString(),
                    price: orders[index].totalPrice.toString(),
                    items: orders[index].productsCount.toString(),
                  );
                },
              ),
            ),
          if (!widget.desktop)
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: OrderCard(
                      id: orders[index].id,
                      state: orders[index].status,
                      date: orders[index].date,
                      orderNum: orders[index].orderNum.toString(),
                      price: orders[index].totalPrice.toString(),
                      items: orders[index].productsCount.toString(),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
