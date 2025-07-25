import 'package:dashboard/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:dashboard/features/Orders/view%20model/cubit/orders_state.dart';
import 'package:dashboard/features/Orders/view/widgets/orders_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    getOrders();
    getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is LoadingOrdersState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SuccessOrdersState) {
          return Scaffold(body: OrdersPageBody());
        } else {
          return Text('Failure');
        }
      },
    );
  }

  Future<void> getOrders() async {
    await BlocProvider.of<OrdersCubit>(context).getAllOrders();
  }

  Future<void> getStatistics() async {
    await BlocProvider.of<OrdersCubit>(context).getStatistics();
  }
}
