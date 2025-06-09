import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:recomindweb/features/product_details/models/recommedation_product.dart';

abstract class ProductDetailsState {}

class InitialProductDetails extends ProductDetailsState {}

class LoadingProductDetails extends ProductDetailsState {}

class SuccessProductDetails extends ProductDetailsState {
  final Product product;
  final List<Recommendation> recommendations;

  SuccessProductDetails({required this.product, required this.recommendations});
}

class ActionSuccessProductDetails extends ProductDetailsState {}

class FailureProductDetails extends ProductDetailsState {
  final Failure failure;

  FailureProductDetails({required this.failure});
}
