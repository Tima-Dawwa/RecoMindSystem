import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Orders/view%20model/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(InitialOrdersState());
}
