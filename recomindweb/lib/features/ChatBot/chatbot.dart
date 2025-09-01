import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/main_panel.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/sidebarwidget.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_cubit.dart';
import 'package:recomindweb/features/ChatBot/Service%20Socket/chat_controller.dart';

class ChatPage extends StatefulWidget {

  const ChatPage({super.key,});

  @override
  _ChatPageWrapperState createState() => _ChatPageWrapperState();
}

class _ChatPageWrapperState extends State<ChatPage> {
  String? _selectedChatId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final chatBotCubit = context.read<ChatBotCubit>();
        ChatController.setChatBotService(chatBotCubit.chatBotService);
      }
    });
  }

  void _handleChatSelected(String? chatId) {
    setState(() {
      _selectedChatId = chatId;
    });
  }

  void _handleNewChat() {
    setState(() {
      _selectedChatId = null;
    });
  }

  void _handleChatIdChanged(String newChatId) {
    setState(() {
      _selectedChatId = newChatId;
    });

    context.read<ChatBotCubit>().getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarWidget(
            currentChatId: _selectedChatId,
            onChatSelected: _handleChatSelected,
            onNewChat: _handleNewChat,
          ),
          Expanded(
            child: CenterPanelWidget(
              chatId: _selectedChatId,
              onChatIdChanged: _handleChatIdChanged,
            ),
          ),
        ],
      ),
    );
  }
}
