import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/response_card.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';
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
      ),
      Product(
        name: "Product B",
        imageUrl: "assets/main_side.png",
        price: 49.99,
      ),
      Product(
        name: "Product C",
        imageUrl: "assets/main_side.png",
        price: 19.99,
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
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child:
                _messages.isEmpty
                    ? const Center(
                      child: Text(
                        'Welcome! Ask anything...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
