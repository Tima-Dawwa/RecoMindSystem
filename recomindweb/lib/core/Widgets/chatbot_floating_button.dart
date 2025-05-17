import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recomindweb/core/chat_controller.dart';
import 'package:recomindweb/core/theme.dart';

class DraggableFloatingButton extends StatefulWidget {
  const DraggableFloatingButton({super.key});

  @override
  State<DraggableFloatingButton> createState() =>
      _DraggableFloatingButtonState();
}

class _DraggableFloatingButtonState extends State<DraggableFloatingButton> {
  Offset position = const Offset(20, 100);
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final chatController = Provider.of<ChatController>(context);

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanEnd: (_) => setState(() => _isDragging = false),
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
              (position.dx + details.delta.dx).clamp(0, screenSize.width - 60),
              (position.dy + details.delta.dy).clamp(0, screenSize.height - 60),
            );
          });
        },
        onTap: () {
          if (!_isDragging) {
            chatController.toggleChat();
          }
        },
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:
                  chatController.isChatOpen ? Themes.secondary : Themes.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (chatController.isChatOpen
                          ? Themes.secondary
                          : Themes.primary)
                      .withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Tooltip(
              message: 'Ask AI Assistant',
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.smart_toy_rounded,
                  size: 28,
                  color:
                      chatController.isChatOpen
                          ? Themes.secondary
                          : Themes.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
