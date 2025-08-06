import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/response_card.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:recomindweb/features/ChatBot/Service%20Socket/chat_controller.dart';

import 'message_bubble.dart';
import 'chat_input_field.dart';

class CenterPanelWidget extends StatefulWidget {
  final String? chatId;
  final String token;
  final Function(String)?
  onChatIdChanged; // Callback to update parent with new chat ID

  const CenterPanelWidget({
    Key? key,
    this.chatId,
    required this.token,
    this.onChatIdChanged,
  }) : super(key: key);

  @override
  _CenterPanelWidgetState createState() => _CenterPanelWidgetState();
}

class _CenterPanelWidgetState extends State<CenterPanelWidget> {
  final TextEditingController _controller = TextEditingController();
  late ChatController _chatController;
  String? _currentChatId;

  @override
  void initState() {
    super.initState();
    _currentChatId = widget.chatId;
    _chatController = ChatController();
    _initializeChat();
  }

  @override
  void didUpdateWidget(CenterPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if chatId has changed
    if (widget.chatId != oldWidget.chatId) {
      _currentChatId = widget.chatId;
      _reinitializeChat();
    }
  }

  Future<void> _initializeChat() async {
    await _chatController.connectToServer( widget.token);

    if (_currentChatId != null) {
      await _chatController.joinChat(_currentChatId!);
    }
  }

  Future<void> _reinitializeChat() async {
    // Clear previous chat state
    _chatController.clearMessages();

    if (_currentChatId != null) {
      await _chatController.joinChat(_currentChatId!);
    }
  }

  void _handleSend(String? text, Uint8List? imageBytes) {
    if ((text == null || text.trim().isEmpty) && imageBytes == null) return;

    // If no current chat ID, create a new chat first
    if (_currentChatId == null) {
      _createNewChatAndSend(text, imageBytes);
    } else {
      _chatController.sendMessage(text: text, imageBytes: imageBytes);
    }

    _controller.clear();
  }

  void _createNewChatAndSend(String? text, Uint8List? imageBytes) async {
    // This would typically involve creating a new chat via your API
    // For now, we'll simulate creating a chat ID
    final newChatId = 'chat_${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      _currentChatId = newChatId;
    });

    // Notify parent about the new chat ID
    if (widget.onChatIdChanged != null) {
      widget.onChatIdChanged!(newChatId);
    }

    // Join the new chat and send the message
    await _chatController.joinChat(newChatId);
    _chatController.sendMessage(text: text, imageBytes: imageBytes);
  }

  void _handleProductTap(Product product) {
    _chatController.onProductTap(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Clicked on ${product.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _chatController,
      child: Consumer<ChatController>(
        builder: (context, controller, child) {
          return Container(
            color: Themes.text,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Connection status indicators
                if (controller.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: controller.clearError,
                        ),
                      ],
                    ),
                  ),

                if (!controller.isConnected)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wifi_off, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Connecting to server...',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),

                // Chat ID indicator (for debugging - can be removed in production)
                if (_currentChatId != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Themes.bg.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Chat ID: $_currentChatId',
                      style: TextStyle(
                        color: Themes.bg.withAlpha(150),
                        fontSize: 12,
                      ),
                    ),
                  ),

                // Messages area
                Expanded(
                  child:
                      controller.hasMessages
                          ? ListView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: controller.messages.length,
                            itemBuilder: (context, index) {
                              final message = controller.messages[index];

                              if (message.type == MessageType.bot &&
                                  message.responseProducts != null &&
                                  message.responseProducts!.isNotEmpty) {
                                return ResponseCards(
                                  products: message.responseProducts!,
                                  onCardTap: _handleProductTap,
                                );
                              }

                              return MessageBubble(message: message);
                            },
                          )
                          : _buildWelcomeScreen(),
                ),

                // Input field
                ChatInputField(
                  controller: _controller,
                  onSubmitted: _handleSend,
                  enabled: controller.isConnected,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Themes.bg.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            _currentChatId == null
                ? 'Start a new conversation'
                : 'Welcome! Ask anything...',
            style: TextStyle(color: Themes.bg.withAlpha(100), fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            _currentChatId == null
                ? 'Type a message below to create a new chat'
                : 'Start a conversation to get product recommendations',
            style: TextStyle(color: Themes.bg.withAlpha(80), fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
