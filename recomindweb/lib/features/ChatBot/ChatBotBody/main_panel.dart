import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/response_card.dart';
import '../Model/chat_message.dart';
import '../Model/product.dart';
import 'message_bubble.dart';
import 'chat_input_field.dart';

class CenterPanelWidget extends StatefulWidget {
  const CenterPanelWidget({Key? key}) : super(key: key);

  @override
  _CenterPanelWidgetState createState() => _CenterPanelWidgetState();
}

class _CenterPanelWidgetState extends State<CenterPanelWidget> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  Future<List<Product>> _simulateBackendResponse() async {
    await Future.delayed(const Duration(seconds: 3));
    return [
      Product(
        name: "Product A",
        imageUrl: "assets/main_side.png",
        price: 29.99,
        discountPercent: 25, 
        isFavorite: false,
        gender: "Female",
        category: "Ladieswear",
        isTrending: true,
        rating: 4.5,
        tagType: "Trend",
      ),
      Product(
        name: "Product B",
        imageUrl: "assets/main_side.png",
        price: 49.99,
        discountPercent: 10,
        isFavorite: true,
        gender: "Male",
        category: "Menswear",
        isTrending: false,
        rating: 3.8,
        tagType: "New",
      ),
      Product(
        name: "Product C",
        imageUrl: "assets/main_side.png",
        price: 19.99,
        discountPercent: null,
        isFavorite: false,
        gender: "Unisex",
        category: "Accessories",
        isTrending: false,
        rating: 4.0,
        tagType: "Trend",
      ),
    ];
  }

  void _handleSend(String? text, Uint8List? imageBytes) {
    if ((text == null || text.trim().isEmpty) && imageBytes == null) return;

    setState(() {
      _messages.add(
        ChatMessage(type: MessageType.user, text: text, imageBytes: imageBytes),
      );
      _messages.add(ChatMessage(type: MessageType.waiting));
    });

    _simulateBackendResponse().then((products) {
      setState(() {
        _messages.removeWhere((msg) => msg.type == MessageType.waiting);
        _messages.add(
          ChatMessage(type: MessageType.bot, responseProducts: products),
        );
      });
    });
  }

  void _handleCardTap(Product product) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Clicked on ${product.name}')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Themes.text,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child:
                _messages.isEmpty
                    ? Center(
                      child: Text(
                        'Welcome! Ask anything...',
                        style: TextStyle(
                          color: Themes.bg.withAlpha(100),
                          fontSize: 18,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        if (msg.type == MessageType.bot &&
                            msg.responseProducts != null) {
                          return ResponseCards(
                            products: msg.responseProducts!,
                            onCardTap: _handleCardTap,
                          );
                        }
                        return MessageBubble(message: msg);
                      },
                    ),
          ),
          ChatInputField(
            controller: _controller,
            onSubmitted: (text, imageBytes) => _handleSend(text, imageBytes),
          ),
        ],
      ),
    );
  }
}
