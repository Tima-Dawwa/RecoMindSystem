import 'package:dashboard/features/AI/model/days_model.dart';

class StatisticsModel {
  final String type;
  final List<DaysModel> days;

  StatisticsModel({required this.type, required this.days});

  factory StatisticsModel.fromJson(jsonData) {
    List<DaysModel> days = [];
    for (int i = 0; i < jsonData['days'].length; i++) {
      days.add(DaysModel.fromJson(jsonData['days'][i]));
    }
    return StatisticsModel(type: jsonData['type'], days: days);
  }
}
