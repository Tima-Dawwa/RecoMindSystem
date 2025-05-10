import 'package:flutter/material.dart';

class DraggableFloatingButton extends StatefulWidget {
  const DraggableFloatingButton({super.key});

  @override
  State<DraggableFloatingButton> createState() =>
      _DraggableFloatingButtonState();
}

class _DraggableFloatingButtonState extends State<DraggableFloatingButton> {
  Offset position = const Offset(20, 100);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: _buildButton(isDragging: true),
        childWhenDragging: const SizedBox(),
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          setState(() {
            position = offset;
          });
        },
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton({bool isDragging = false}) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Tooltip(
          message: 'Ask AI Assistant',
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("How can I help you?")),
              );
            },
            child: CircleAvatar(
              radius: isDragging ? 28 : 26,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.smart_toy_rounded,
                size: 28,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
