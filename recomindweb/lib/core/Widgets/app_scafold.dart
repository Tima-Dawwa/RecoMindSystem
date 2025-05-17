import 'package:flutter/material.dart';
import 'package:recomindweb/core/Widgets/chatbot_floating_button.dart';
import 'package:recomindweb/core/theme.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.bg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              child,
              const DraggableFloatingButton(),
            ],
          ),
        ),
      ),
    );
  }
}
