class OrdersStatistics {
  final int orders;
  final int users;
  final int profits;

  OrdersStatistics({
    required this.orders,
    required this.users,
    required this.profits,
  });

  factory OrdersStatistics.fromJson(jsonData) {
    return OrdersStatistics(
      orders: jsonData['total_orders'],
      users: jsonData['unique_users'],
      profits: jsonData['total_profit'],
    );
  }
}
