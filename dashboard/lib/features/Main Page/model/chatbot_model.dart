class ChatbotModel {
  final int text;
  final int image;
  final int both;

  ChatbotModel({required this.image, required this.text, required this.both});

  factory ChatbotModel.fromJson(jsonData) {
    return ChatbotModel(
      text: jsonData['text'],
      image: jsonData['image'],
      both: jsonData['text+image'],
    );
  }
}
