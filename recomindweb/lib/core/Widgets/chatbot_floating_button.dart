import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class DraggableFloatingButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isChatOpen;

  const DraggableFloatingButton({
    super.key,
    this.onPressed,
    this.isChatOpen = false,
  });

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
    final buttonSize = 60.0;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanEnd: (_) => setState(() => _isDragging = false),
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
              (position.dx + details.delta.dx).clamp(
                0,
                screenSize.width - buttonSize,
              ),
              (position.dy + details.delta.dy).clamp(
                0,
                screenSize.height - buttonSize,
              ),
            );
          });
        },
        onTap: () {
          if (!_isDragging) {
            widget.onPressed?.call();
          }
        },
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.isChatOpen ? Themes.secondary : Themes.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.isChatOpen ? Themes.secondary : Themes.primary)
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
                  color: widget.isChatOpen ? Themes.secondary : Themes.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
