class OrderModel {
  final String id;
  final String status;
  final String? name;
  final String date;
  final int productsCount;
  final double totalPrice;

  OrderModel({
    required this.productsCount,
    required this.totalPrice,
    required this.id,
    required this.status,
    required this.name,
    required this.date,
  });

  factory OrderModel.fromJson(jsonData) {
    return OrderModel(
      id: jsonData['id'],
      status: jsonData['status'],
      date: jsonData['order_date'],
      productsCount: jsonData['products_count'],
      totalPrice: jsonData['total_price'],
      name: jsonData['username'],
    );
  }
}
