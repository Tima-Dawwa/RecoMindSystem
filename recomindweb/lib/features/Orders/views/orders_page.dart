import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:recomindweb/features/Orders/view%20model/cubit/orders_state.dart';
import 'package:recomindweb/features/Orders/views/widgets/orders_page_body.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is LoadingOrdersState) {
            return Center(child: CustomLoading());
          } else if (state is SuccessOrdersState) {
            return ResponsiveLayout(
              mobileBody: OrdersPageBody(desktop: false),
              desktopBody: OrdersPageBody(desktop: true),
            );
          } else {
            return Text('Failure');
          }
        },
      ),
    );
  }

  Future<void> getOrders() async {
    await BlocProvider.of<OrdersCubit>(context).getAllOrders();
  }
}
