import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/response_card.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/welcomeMessage.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';

import 'chat_input_field.dart';
import 'message_bubble.dart';

class CenterPanelWidget extends StatefulWidget {
  const CenterPanelWidget({super.key});

  @override
  _CenterPanelWidgetState createState() => _CenterPanelWidgetState();
}

class _CenterPanelWidgetState extends State<CenterPanelWidget> {
  final List<ChatMessage> _messages = [];

  // Controller to manage the text input
  final TextEditingController _controller = TextEditingController();

  // Simulate backend call with delay
  Future<List<Product>> _simulateBackendResponse() async {
    await Future.delayed(const Duration(seconds: 3)); // simulate network delay

    // Sample product list, replace with your logic
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

  void _handleSend({String? text, Uint8List? imageBytes}) {
    if ((text == null || text.trim().isEmpty) && imageBytes == null) return;

    setState(() {
      // Add user message
      _messages.add(
        ChatMessage(type: MessageType.user, text: text, imageBytes: imageBytes),
      );

      // Add waiting message
      _messages.add(ChatMessage(type: MessageType.waiting));
    });

    // Clear input field and selected image
    _controller.clear();

    // Simulate backend response after delay
    _simulateBackendResponse().then((products) {
      setState(() {
        // Remove the waiting message
        _messages.removeWhere((msg) => msg.type == MessageType.waiting);

        // Add bot message with response products
        _messages.add(
          ChatMessage(type: MessageType.bot, responseProducts: products),
        );
      });
    });
  }

  void _handleCardTap(Product product) {
    // Handle card click - for demo, just show a snackbar
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
                    ? const WelcomeMessage()
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
            onSubmitted: (text) => _handleSend(text: text),
            onImageSelected:
                (imageBytes) => _handleSend(imageBytes: imageBytes),
          ),
        ],
      ),
    );
  }
}
