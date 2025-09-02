class OrderModel {
  final String id;
  final String status;
  final String date;
  final int productsCount;
  final double totalPrice;
  final int orderNum;

  OrderModel({
    required this.orderNum,
    required this.productsCount,
    required this.totalPrice,
    required this.id,
    required this.status,
    required this.date,
  });

  factory OrderModel.fromJson(jsonData) {
    return OrderModel(
      id: jsonData['order_id'],
      status: jsonData['status'],
      date: jsonData['created_at'],
      productsCount: jsonData['products_count'],
      totalPrice: jsonData['total_price'],
      orderNum: jsonData['order_number'],
    );
  }
}
