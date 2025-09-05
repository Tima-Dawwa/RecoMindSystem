import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/response_card.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:recomindweb/features/ChatBot/Service%20Socket/chat_controller.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_cubit.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_status.dart';
import 'message_bubble.dart';
import 'chat_input_field.dart';

class CenterPanelWidget extends StatefulWidget {
  final String? chatId;
  final Function(String)? onChatIdChanged;

  const CenterPanelWidget({super.key, this.chatId, this.onChatIdChanged});

  @override
  _CenterPanelWidgetState createState() => _CenterPanelWidgetState();
}

class _CenterPanelWidgetState extends State<CenterPanelWidget> {
  final TextEditingController _controller = TextEditingController();
  late ChatController _chatController;
  String? _currentChatId;
  bool _isCreatingChat = false;
  bool _hasAutoCreatedChat = false;

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

    if (widget.chatId != oldWidget.chatId) {
      _currentChatId = widget.chatId;
      _hasAutoCreatedChat = _currentChatId != null;
      _reinitializeChat();
    }
  }

  Future<void> _initializeChat() async {
    await _chatController.connectToServer();

    if (_currentChatId != null) {
      await _chatController.joinChat(_currentChatId!);
      _hasAutoCreatedChat = true;
    } else if (!_hasAutoCreatedChat) {
      await _autoCreateNewChat();
    }
  }

  Future<void> _reinitializeChat() async {
    _chatController.clearMessages();

    if (_currentChatId != null) {
      await _chatController.joinChat(_currentChatId!);
    } else if (!_hasAutoCreatedChat) {
      await _autoCreateNewChat();
    }
  }

  Future<void> _autoCreateNewChat() async {
    if (_isCreatingChat || _hasAutoCreatedChat) return;

    setState(() {
      _isCreatingChat = true;
    });

    try {
      final chatBotCubit = context.read<ChatBotCubit>();

      final subscription = chatBotCubit.stream.listen((state) {
        if (state is ChatCreatedSuccessfully) {
          setState(() {
            _currentChatId = state.chatId;
            _hasAutoCreatedChat = true;
          });

          if (widget.onChatIdChanged != null) {
            widget.onChatIdChanged!(state.chatId);
          }

          _chatController.joinChat(state.chatId);
        } else if (state is FailureChatBot) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to auto-create chat: ${state.failure.errMessage}',
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }

        if (state is! LoadingChatBot) {
          setState(() {
            _isCreatingChat = false;
          });
        }
      });

      await chatBotCubit.creatChat();

      Future.delayed(const Duration(seconds: 2), () {
        subscription.cancel();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error auto-creating chat: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      setState(() {
        _isCreatingChat = false;
      });
    }
  }

  void _handleSend(String? text, Uint8List? imageBytes) {
    if ((text == null || text.trim().isEmpty) && imageBytes == null) return;

    if (_currentChatId == null) {
      _createNewChatAndSend(text, imageBytes);
    } else {
      _chatController.sendMessage(text: text, imageBytes: imageBytes);
    }

    _controller.clear();
  }

  void _createNewChatAndSend(String? text, Uint8List? imageBytes) async {
    if (_isCreatingChat) return;

    setState(() {
      _isCreatingChat = true;
    });

    try {
      final chatBotCubit = context.read<ChatBotCubit>();
      await chatBotCubit.creatChat();

      final newChatId = chatBotCubit.currentChatId;

      if (newChatId != null) {
        setState(() {
          _currentChatId = newChatId;
          _hasAutoCreatedChat = true;
        });

        if (widget.onChatIdChanged != null) {
          widget.onChatIdChanged!(newChatId);
        }

        await _chatController.joinChat(newChatId);
        _chatController.sendMessage(text: text, imageBytes: imageBytes);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create new chat. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating chat: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isCreatingChat = false;
      });
    }
  }

  void _handleProductTap(ProductModel product) {
    _chatController.onProductTap(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Clicked on ${product.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildMessageWithProducts(ChatMessage message, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.responseProducts != null &&
            message.responseProducts!.isNotEmpty)
          ResponseCards(
            products: message.responseProducts!,
            onCardTap: _handleProductTap,
          ),

        if (message.text != null && message.text!.trim().isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Themes.bg.withAlpha(100),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message.text!, style: TextStyle(color: Themes.text)),
                ],
              ),
            ),
          ),
      ],
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

                if (_isCreatingChat)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _hasAutoCreatedChat
                              ? 'Creating new chat...'
                              : 'Setting up chat...',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),

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
                                return _buildMessageWithProducts(
                                  message,
                                  index,
                                );
                              }

                              return MessageBubble(message: message);
                            },
                          )
                          : _buildWelcomeScreen(),
                ),

                ChatInputField(
                  controller: _controller,
                  onSubmitted: _handleSend,
                  enabled:
                      controller.isConnected &&
                      !_isCreatingChat &&
                      _currentChatId != null,
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
                ? (_isCreatingChat
                    ? 'Setting up your chat...'
                    : 'Starting conversation...')
                : 'Welcome! Ask anything...',
            style: TextStyle(color: Themes.bg.withAlpha(100), fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            _currentChatId == null
                ? 'Please wait while we prepare your chat'
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
