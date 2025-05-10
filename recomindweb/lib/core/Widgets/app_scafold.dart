import 'package:flutter/material.dart';
import 'package:recomindweb/core/Widgets/chatbot_floating_button.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            child,
            const DraggableFloatingButton(), 
          ],
        ),
      ),
    );
  }
}
