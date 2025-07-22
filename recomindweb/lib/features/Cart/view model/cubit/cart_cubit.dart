import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_state.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitialState());
}
