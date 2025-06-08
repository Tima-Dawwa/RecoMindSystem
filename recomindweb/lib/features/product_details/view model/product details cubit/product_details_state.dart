import 'package:recomindweb/core/helpers/failure.dart';

abstract class ProductDetailsState {}

class InitialProductDetails extends ProductDetailsState {}

class LoadingProductDetails extends ProductDetailsState {}

class SuccessProductDetails extends ProductDetailsState {}

class FailureProductDetails extends ProductDetailsState {
  final Failure failure;

  FailureProductDetails({required this.failure});
}
