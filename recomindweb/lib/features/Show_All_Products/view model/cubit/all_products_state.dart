import 'package:recomindweb/core/helpers/failure.dart';

class AllProductsState {}

class AllProductsInitialState extends AllProductsState {}

class AllProductsLoadingState extends AllProductsState {}

class AllProductsSuccessState extends AllProductsState {}

class AllProductsFailureState extends AllProductsState {
  final Failure failure;
  AllProductsFailureState({required this.failure});
}

class AllProductsFilterState extends AllProductsState {}

class SmartSearchLoadingState extends AllProductsState {}

class SmartSearchSuccessState extends AllProductsState {}

class SmartSearchFailureState extends AllProductsState {
  final Failure failure;
  SmartSearchFailureState({required this.failure});
}
