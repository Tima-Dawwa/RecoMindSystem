import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Cart/model/cart_model.dart';
import 'package:recomindweb/features/Cart/view%20model/cart_service.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_state.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit(this.cartService) : super(CartInitialState());
  final CartService cartService;
  List<CartModel> cartItems = [];
  String? messageDeleted;

  Future<void> getCart() async {
    emit(CartLoadingState());
    var response = await cartService.getCart();
    response.fold(
      (failure) {
        emit(CartFailureState(failure: failure));
      },
      (res) {
        cartItems = [];
        for (var i = 0; i < res['data'].length; i++) {
          cartItems.add(CartModel.fromJson(res["data"][i]));
        }
        emit(CartSuccessState());
      },
    );
  }

  Future<void> removeFromCart(String id) async {
    emit(CartLoadingState());
    var response = await cartService.removeFromCart(id);
    response.fold(
      (failure) {
        emit(CartFailureState(failure: failure));
      },
      (res) {
        messageDeleted = res['message'];
        emit(CartSuccessState());
      },
    );
  }
}
