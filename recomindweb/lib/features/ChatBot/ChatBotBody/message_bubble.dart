import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.waiting) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final bool isUser = message.type == MessageType.user;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Themes.bg : Themes.bg.withAlpha(100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.imageBytes != null || message.imagePath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildImage(),
              ),

            if (message.text != null && message.text!.trim().isNotEmpty)
              Text(message.text!, style: TextStyle(color: Themes.text)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (message.imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(message.imageBytes!, width: 150, fit: BoxFit.cover),
      );
    }

    if (message.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          message.imagePath!,
          width: 150,
          fit: BoxFit.cover,
          headers: {"ngrok-skip-browser-warning": "true"},
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 150,
              height: 100,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 150,
              height: 100,
              color: Colors.red[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: Colors.red),
                  Text(
                    'Image failed to load',
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return SizedBox.shrink();
  }
}
