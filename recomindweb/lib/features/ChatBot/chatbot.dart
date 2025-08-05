import 'package:flutter/material.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/main_panel.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/sidebarwidget.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarWidget(),
          Expanded(
            child: CenterPanelWidget(
              serverUrl: 'https://85fe4d4072e4.ngrok-free.app',
              token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijg3Njg2ZmVhYzc2YjY4YjIwYjdlYWU0ZiIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6IkphbmUiLCJsYXN0X25hbWUiOiJZdW5kdCJ9LCJpYXQiOjE3NTQ0MDgxMzgsImV4cCI6MTc1NDY2NzMzOH0.TJr1bbj9hi7_oJiucJfnNh7Nkorm-DUCZ1dZlqMk6EU',
            ),
          ),
        ],
      ),
    );
  }
}
