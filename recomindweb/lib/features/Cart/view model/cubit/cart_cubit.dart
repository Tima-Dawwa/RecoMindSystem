import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Cart/model/cart_model.dart';
import 'package:recomindweb/features/Cart/view%20model/cart_service.dart';
import 'package:recomindweb/features/Cart/view%20model/cubit/cart_state.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit(this.cartService) : super(CartInitialState());
  final CartService cartService;
  List<CartModel> cartItems = [];
  List<AllProductsModel> hybridProducts = [];
  String? messageDeleted;
  String? orderId;
  String? messageSuccess;

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
        hybridProducts = [];
        for (var i = 0; i < res['recommendations'].length; i++) {
          hybridProducts.add(
            AllProductsModel.fromjson(res["recommendations"][i]),
          );
        }
        emit(CartSuccessState());
      },
    );
  }

  Future<void> removeFromCart(String id, BuildContext context) async {
    emit(RemoveFromCartLoadingState());
    var response = await cartService.removeFromCart(id);
    await Future.delayed(const Duration(milliseconds: 10));
    response.fold(
      (failure) {
        emit(RemoveFromCartFailureState(failure: failure));
      },
      (res) {
        messageDeleted = res['message'];
        cartItems.removeWhere((item) => item.id == id);
        emit(RemoveFromCartSuccessState(message: messageDeleted!));
        Navigator.pop(context);
      },
    );
  }

  void increaseQuantity(int index) {
    final item = cartItems[index];
    cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    emit(CartSuccessState());
  }

  void decreaseQuantity(int index) {
    final item = cartItems[index];
    if (item.quantity > 1) {
      cartItems[index] = item.copyWith(quantity: item.quantity - 1);
      emit(CartSuccessState());
    }
  }

  Future<void> makeOrder() async {
    emit(MakeOrderLoadingState());

    final body = buildCartBody(cartItems);
    final jsonBody = jsonEncode(body);

    var response = await cartService.makeOrder(jsonBody);
    await Future.delayed(const Duration(milliseconds: 10));
    response.fold(
      (failure) {
        emit(MakeOrderFailureState(failure: failure));
      },
      (res) {
        orderId = res['order_id'];
        messageSuccess = res['message'];
        cartItems.clear();
        emit(
          MakeOrderSuccessState(message: messageSuccess!, orderId: orderId!),
        );
      },
    );
  }

  Map<String, dynamic> buildCartBody(List<CartModel> cartItems) {
    // double totalPrice = 0;

    final items =
        cartItems.map((item) {
          // totalPrice += item.price * item.quantity;
          return {
            "product": item.id,
            "quantity": item.quantity,
            "price": item.price,
          };
        }).toList();

    return {
      "items": items,
      // "total_price": totalPrice
    };
  }

  Future<void> addToFavorites({
    required String productId,
    required int index,
  }) async {
    emit(CartLoadingState());
    final response = await cartService.addToFavorites(productId: productId);
    response.fold(
      (failure) {
        emit(CartFailureState(failure: failure));
      },
      (res) {
        final item = hybridProducts[index];
        hybridProducts[index] = item.copyWith(isFav: true);
        emit(CartSuccessState());
      },
    );
  }

  Future<void> deleteFavorite({
    required String productId,
    required int index,
  }) async {
    emit(CartLoadingState());
    final response = await cartService.deleteFavorite(favoriteId: productId);
    response.fold(
      (failure) {
        emit(CartFailureState(failure: failure));
      },
      (res) {
        final item = hybridProducts[index];
        hybridProducts[index] = item.copyWith(isFav: false);
        emit(CartSuccessState());
      },
    );
  }
}
