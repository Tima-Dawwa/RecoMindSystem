import 'package:recomindweb/core/helpers/failure.dart';

class AllProductsState {}

class AllProductsInitialState extends AllProductsState {}

class AllProductsLoadingState extends AllProductsState {}

class AllProductsSuccessState extends AllProductsState {}

class AllProductsFailureState extends AllProductsState {
  final Failure failure;
  AllProductsFailureState({required this.failure});
}

class AllProductsFilterState extends AllProductsState{}