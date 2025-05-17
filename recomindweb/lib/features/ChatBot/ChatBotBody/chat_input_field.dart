import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<Uint8List?> onImageSelected;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onImageSelected,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  Uint8List? _webImageBytes;

  void _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _webImageBytes = result.files.single.bytes;
      });
      widget.onImageSelected(_webImageBytes);
    }
  }

  void _submit() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted(text);
      widget.controller.clear();
      setState(() {
        _webImageBytes = null; // Clear selected image after sending
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _webImageBytes != null ? Icons.image : Icons.file_upload,
              color: Colors.white,
            ),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Ask anything',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          if (hasText)
            IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _submit,
            ),
        ],
      ),
    );
  }
}
