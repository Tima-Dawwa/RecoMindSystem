class TimeModel {
  final String type;
  final double value;

  TimeModel({required this.value, required this.type});

  factory TimeModel.fromJson(jsonData) {
    return TimeModel(
      type: jsonData['type'],
      value: jsonData['avgResponseTime'],
    );
  }
}
