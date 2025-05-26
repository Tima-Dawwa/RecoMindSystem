import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "What can I help with?",
        style: TextStyle(color: Themes.bg.withAlpha(100), fontSize: 24),
      ),
    );
  }
}
