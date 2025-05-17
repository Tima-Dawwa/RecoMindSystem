import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/welcomeMessage.dart';
import 'chat_input_field.dart'; // Your custom input field

class CenterPanelWidget extends StatefulWidget {
  @override
  _CenterPanelWidgetState createState() => _CenterPanelWidgetState();
}

class _CenterPanelWidgetState extends State<CenterPanelWidget> {
  bool hasStartedConversation = false;
  final TextEditingController _controller = TextEditingController();

  void _handleSubmit(String value) {
    if (value.trim().isEmpty) return;

    setState(() {
      hasStartedConversation = true;
    });

    // Here you can also trigger message sending logic
    print("Text submitted: $value");

    _controller.clear();
  }

  void _handleImage(File? image) {
    if (image != null) {
      print("Image selected: ${image.path}");

      setState(() {
        hasStartedConversation = true;
      });

      // You can also handle sending image here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          hasStartedConversation
              ? Expanded(child: Container())
              : const Expanded(child: WelcomeMessage()),
          ChatInputField(
            controller: _controller,
            onSubmitted: _handleSubmit,
            onImageSelected: _handleImage,
          ),
        ],
      ),
    );
  }
}
