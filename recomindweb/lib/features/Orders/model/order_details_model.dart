import 'package:recomindweb/features/Orders/model/product_model.dart';

class OrderDetailsModel {
  final String id;
  final String status;
  final String date;
  final int productsCount;
  final int totalPrice;
  final List<ProductModel> products;

  OrderDetailsModel({
    required this.products,
    required this.productsCount,
    required this.totalPrice,
    required this.id,
    required this.status,
    required this.date,
  });

  factory OrderDetailsModel.fromJson(jsonData) {
    List<ProductModel> products = [];
    for (int i = 0; i < jsonData['products'].length; i++) {
      products.add(ProductModel.fromJson(jsonData['products'][i]));
    }
    return OrderDetailsModel(
      id: jsonData['order_id'],
      status: jsonData['status'],
      date: jsonData['created_at'],
      productsCount: jsonData['products_count'],
      totalPrice: jsonData['total_price'],
      products: products,
    );
  }
}
