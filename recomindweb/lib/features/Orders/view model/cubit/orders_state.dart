import 'package:recomindweb/core/helpers/failure.dart';

abstract class OrdersState {}

class InitialOrdersState extends OrdersState {}

class LoadingOrdersState extends OrdersState {}

class SuccessOrdersState extends OrdersState {}

class FailureOrdersState extends OrdersState {
  final Failure failure;
  FailureOrdersState({required this.failure});
}
