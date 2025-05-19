import 'dart:typed_data';

import 'product.dart';

enum MessageType { user, bot, waiting }

class ChatMessage {
  final MessageType type;
  final String? text;
  final Uint8List? imageBytes;
  final List<Product>? responseProducts;

  ChatMessage({
    required this.type,
    this.text,
    this.imageBytes,
    this.responseProducts,
  });
}



