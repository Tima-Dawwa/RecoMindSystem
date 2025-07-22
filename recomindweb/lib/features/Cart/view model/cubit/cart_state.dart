import 'package:recomindweb/core/helpers/failure.dart';

class CartStates {}

class CartInitialState extends CartStates {}

class CartLoadingState extends CartStates {}

class CartSuccessState extends CartStates {}

class CartFailureState extends CartStates {
  final Failure failure;
  CartFailureState({required this.failure});
}
