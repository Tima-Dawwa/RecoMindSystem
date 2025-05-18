import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String text, Uint8List? imageBytes) onSubmitted;

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  Uint8List? _pickedImage;

  void _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _pickedImage = result.files.single.bytes;
      });
    }
  }

  void _submit() {
    final text = widget.controller.text.trim();
    if (text.isEmpty && _pickedImage == null) return;

    widget.onSubmitted(text, _pickedImage);
    widget.controller.clear();
    setState(() {
      _pickedImage = null;
    });
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
              _pickedImage != null ? Icons.image : Icons.file_upload,
              color: Colors.white,
            ),
            onPressed: _pickImage,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: widget.controller,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Ask anything',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
                if (_pickedImage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 80,
                    child: Image.memory(_pickedImage!),
                  ),
              ],
            ),
          ),
          if (hasText || _pickedImage != null)
            IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _submit,
            ),
        ],
      ),
    );
  }
}
