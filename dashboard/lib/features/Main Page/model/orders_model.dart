class OrdersModel {
  final int orders;
  final double spent;
  final String name;

  OrdersModel({required this.spent, required this.orders, required this.name});

  factory OrdersModel.fromJson(jsonData) {
    return OrdersModel(
      orders: jsonData['order_count'],
      spent: jsonData['total_spent'],
      name: jsonData['full_name'],
    );
  }
}
