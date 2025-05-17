import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<File?> onImageSelected;

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
  File? _selectedImage;

void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.onImageSelected(_selectedImage);
    }
  }


  void _submit() {
    if (widget.controller.text.trim().isNotEmpty) {
      widget.onSubmitted(widget.controller.text.trim());
      widget.controller.clear();
      setState(() {
        _selectedImage = null;
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
              _selectedImage != null ? Icons.image : Icons.file_upload,
              color: Colors.white,
            ),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}), 
              decoration: InputDecoration(
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
