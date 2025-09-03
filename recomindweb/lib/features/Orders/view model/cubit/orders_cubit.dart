import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Orders/model/order_details_model.dart';
import 'package:recomindweb/features/Orders/model/orders_model.dart';
import 'package:recomindweb/features/Orders/view%20model/cubit/orders_state.dart';
import 'package:recomindweb/features/Orders/view%20model/orders_services.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this.ordersService) : super(InitialOrdersState());

  final OrdersService ordersService;
  List<OrderModel> orders = [];
  OrderDetailsModel? orderDetails;
  String sortBy = 'createdAt';
  String sortOrder = 'desc';

  Future<void> getAllOrders() async {
    emit(LoadingOrdersState());
    var response = await ordersService.getAllOrders(
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
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

  Future<void> getOneOrder({required String orderId}) async {
    emit(LoadingOrdersState());
    var response = await ordersService.getOneOrder(orderId: orderId);
    response.fold(
      (failure) {
        emit(FailureOrdersState(failure: failure));
      },
      (res) {
        orderDetails = OrderDetailsModel.fromJson(res["data"]);
        emit(SuccessOrdersState());
      },
    );
  }
}
