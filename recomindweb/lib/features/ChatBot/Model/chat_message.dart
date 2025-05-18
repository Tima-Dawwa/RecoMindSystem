import 'dart:typed_data';

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

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final double? discountPercent;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.discountPercent,
  });
}
