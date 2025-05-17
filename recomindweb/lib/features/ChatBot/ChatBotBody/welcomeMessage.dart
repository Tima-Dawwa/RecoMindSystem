import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "What can I help with?",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
