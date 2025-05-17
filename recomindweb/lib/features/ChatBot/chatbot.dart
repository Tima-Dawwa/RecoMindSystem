import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/main_panel.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/sidebarwidget.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [SidebarWidget(), Expanded(child: CenterPanelWidget())],
      ),
    );
  }
}
