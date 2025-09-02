import 'package:recomindweb/core/helpers/failure.dart';

class CartStates {}

class CartInitialState extends CartStates {}

class CartLoadingState extends CartStates {}

class CartSuccessState extends CartStates {}

class CartFailureState extends CartStates {
  final Failure failure;
  CartFailureState({required this.failure});
}

class RemoveFromCartLoadingState extends CartStates {}

class RemoveFromCartSuccessState extends CartStates {
  final String message;
  RemoveFromCartSuccessState({required this.message});
}

class RemoveFromCartFailureState extends CartStates {
  final Failure failure;
  RemoveFromCartFailureState({required this.failure});
}

class DecreaseQuantityState extends CartStates {}

class IncreaseQuantityState extends CartStates {}

class MakeOrderLoadingState extends CartStates {}

class MakeOrderSuccessState extends CartStates {
  final String message;
  final String orderId;
  MakeOrderSuccessState( {required this.message , required this.orderId});
}

class MakeOrderFailureState extends CartStates {
  final Failure failure;
  MakeOrderFailureState({required this.failure});
}
