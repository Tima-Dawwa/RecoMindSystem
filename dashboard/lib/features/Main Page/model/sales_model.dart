class SalesModel {
  final String month;
  final double sales;

  SalesModel({required this.sales, required this.month});

  factory SalesModel.fromJson(jsonData) {
    return SalesModel(month: jsonData['month'], sales: jsonData['totalSales']);
  }
}
