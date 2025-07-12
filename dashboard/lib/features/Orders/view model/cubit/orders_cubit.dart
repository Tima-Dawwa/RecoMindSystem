import 'package:dashboard/features/Orders/model/orders_model.dart';
import 'package:dashboard/features/Orders/model/orders_statistics.dart';
import 'package:dashboard/features/Orders/view%20model/cubit/orders_state.dart';
import 'package:dashboard/features/Orders/view%20model/orders_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this.ordersService) : super(InitialOrdersState());

  final OrdersService ordersService;
  List<OrderModel> orders = [];
  OrdersStatistics? orderDetails;

  Future<void> getAllOrders() async {
    emit(LoadingOrdersState());
    var response = await ordersService.getAllOrders();
    response.fold(
      (failure) {
        emit(FailureOrdersState(failure: failure));
      },
      (res) {
        orders = [];
        for (var i = 0; i < res['data'].length; i++) {
          orders.add(OrderModel.fromJson(res["data"][i]));
        }
        emit(SuccessOrdersState());
      },
    );
  }

  Future<void> getStatistics() async {
    emit(LoadingOrdersState());
    var response = await ordersService.getStatistics();
    response.fold(
      (failure) {
        emit(FailureOrdersState(failure: failure));
      },
      (res) {
        orderDetails = OrdersStatistics.fromJson(res["data"]);
        emit(SuccessOrdersState());
      },
    );
  }
}
