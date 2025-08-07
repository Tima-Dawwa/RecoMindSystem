import 'dart:typed_data';
import 'package:recomindweb/features/ChatBot/Model/product.dart';

enum MessageType { user, bot, waiting }

class ChatMessage {
  final MessageType type;
  final String? text;
  final DateTime timestamp;
  final Uint8List? imageBytes;
  final String? imagePath;
  final List<Product>? responseProducts;

  ChatMessage({
    required this.type,
    this.text,
    DateTime? timestamp,
    this.imageBytes,
    this.imagePath,
    this.responseProducts,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get hasContent =>
      (text != null && text!.trim().isNotEmpty) ||
      imageBytes != null ||
      imagePath != null ||
      (responseProducts != null && responseProducts!.isNotEmpty);

  bool get hasImage => imageBytes != null || imagePath != null;

  bool get hasProducts =>
      responseProducts != null && responseProducts!.isNotEmpty;

  factory ChatMessage.user({
    String? text,
    Uint8List? imageBytes,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      type: MessageType.user,
      text: text,
      imageBytes: imageBytes,
      timestamp: timestamp,
    );
  }

  factory ChatMessage.bot({
    String? text,
    String? imagePath,
    List<Product>? responseProducts,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      type: MessageType.bot,
      text: text,
      imagePath: imagePath,
      responseProducts: responseProducts,
      timestamp: timestamp,
    );
  }

  factory ChatMessage.waiting() {
    return ChatMessage(type: MessageType.waiting);
  }

 
}
