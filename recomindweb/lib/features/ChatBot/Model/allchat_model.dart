class AllchatModel {
  final String id;
  final String title;

  AllchatModel({required this.id, required this.title});

  factory AllchatModel.fromJson(Map<String, dynamic> json) {
    return AllchatModel(id: json['id'], title: json['chat_name']);
  }
}
