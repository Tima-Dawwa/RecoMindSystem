import 'package:flutter/material.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';
import 'dart:typed_data';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case MessageType.user:
        return _buildUserMessage(context);
      case MessageType.waiting:
        return _buildWaitingMessage(context);
      case MessageType.bot:
      default:
        return _buildBotMessage(context);
    }
  }

  Widget _buildUserMessage(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.text != null)
              Text(message.text!, style: const TextStyle(color: Colors.white)),
            if (message.imageBytes != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.memory(
                  message.imageBytes!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingMessage(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Please wait...",
          style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget _buildBotMessage(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            message.text != null
                ? Text(
                  message.text!,
                  style: const TextStyle(color: Colors.white),
                )
                : const SizedBox(),
      ),
    );
  }
}
