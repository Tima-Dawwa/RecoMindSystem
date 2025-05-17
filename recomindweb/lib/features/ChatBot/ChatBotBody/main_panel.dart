import 'package:flutter/material.dart';
import 'package:recomindweb/features/ChatBot/ChatBotBody/welcomeMessage.dart';
import 'chat_input_field.dart';
import 'dart:typed_data'; // Needed for Uint8List

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

    print("Text submitted: $value");
    _controller.clear();
  }

  void _handleImage(Uint8List? imageBytes) {
    if (imageBytes != null) {
      print("Image selected with ${imageBytes.length} bytes");

      setState(() {
        hasStartedConversation = true;
      });

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
              ? const Expanded(child: SizedBox())
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
