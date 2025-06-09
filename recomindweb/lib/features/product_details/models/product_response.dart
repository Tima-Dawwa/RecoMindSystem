import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/models/recommedation_product.dart';

class ProductResponse {
  final Product data;
  final List<Recommendation> recommendations;

  ProductResponse({required this.data, required this.recommendations});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      data: json['data'],
      recommendations:
          (json['recommendations'] as List)
              .map((e) => Recommendation.fromJson(e))
              .toList(),
    );
  }
}
