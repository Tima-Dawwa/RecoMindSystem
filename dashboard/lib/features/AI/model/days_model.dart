class DaysModel {
  final String day;
  final double value;

  DaysModel({required this.value, required this.day});

  factory DaysModel.fromJson(jsonData) {
    return DaysModel(day: jsonData['day'], value: jsonData['avgSimilarity']);
  }
}
