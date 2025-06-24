

import 'package:dashboard/core/helper/failure.dart';

abstract class AddProductState {}

class InitialAddProduct extends AddProductState {}

class LoadingAddProduct extends AddProductState {}

class SuccessAddProduct extends AddProductState {
  final String message;

  SuccessAddProduct({required this.message,});
}


class FailureAddProduct extends AddProductState {
  final Failure failure;

  FailureAddProduct({required this.failure});
}
