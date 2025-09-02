class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
  });

  factory NotificationModel.fromJson(jsonData) {
    return NotificationModel(
      id: jsonData['id'],
      title: jsonData['notification_title'],
      body: jsonData['notification_body'],
      date: jsonData['created_at'],
    );
  }
}
