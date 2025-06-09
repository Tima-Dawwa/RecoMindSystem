import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/features/product_details/models/product_response.dart';

abstract class ProductDetailsState {}

class InitialProductDetails extends ProductDetailsState {}

class LoadingProductDetails extends ProductDetailsState {}

class SuccessProductDetails extends ProductDetailsState {
  final ProductResponse product;

  SuccessProductDetails({required this.product});
}

class ActionSuccessProductDetails extends ProductDetailsState {}

class FailureProductDetails extends ProductDetailsState {
  final Failure failure;

  FailureProductDetails({required this.failure});
}
