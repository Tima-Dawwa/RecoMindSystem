import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recomindweb/core/chat_controller.dart';
import 'package:recomindweb/core/theme.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Themes.primary),
          child: Row(
            children: [
              const Icon(Icons.smart_toy_rounded, color: Colors.white),
              const SizedBox(width: 10),
              const Text(
                'AI Assistant',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed:
                    () =>
                        Provider.of<ChatController>(
                          context,
                          listen: false,
                        ).closeChat(),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: const [Text('Hello! How can I help you today?')],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Themes.primary),
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
