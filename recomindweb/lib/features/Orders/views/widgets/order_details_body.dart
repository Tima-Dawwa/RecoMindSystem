import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Orders/model/order_details_model.dart';
import 'package:recomindweb/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:recomindweb/features/Orders/views/widgets/order_info.dart';
import 'package:recomindweb/features/Orders/views/widgets/products_table.dart';

class OrderDetailsBody extends StatefulWidget {
  const OrderDetailsBody({super.key, required this.desktop});
  final bool desktop;

  @override
  State<OrderDetailsBody> createState() => _OrderDetailsBodyState();
}

class _OrderDetailsBodyState extends State<OrderDetailsBody> {
  OrderDetailsModel? orderDetails;

  @override
  void initState() {
    super.initState();
    orderDetails = BlocProvider.of<OrdersCubit>(context).orderDetails;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: widget.desktop ? 25 : 15,
          horizontal: widget.desktop ? 40 : 20,
        ),
        child: Column(
          children: [
            OrderInfo(
              desktop: widget.desktop,
              state: orderDetails!.status,
              orderNum: orderDetails!.id.substring(0, 4),
              date: orderDetails!.date,
              price: orderDetails!.totalPrice.toString(),
            ),
            SizedBox(height: 15),
            ProductsTable(
              desktop: widget.desktop,
              products: orderDetails!.products,
            ),
          ],
        ),
      ),
    );
  }
}
