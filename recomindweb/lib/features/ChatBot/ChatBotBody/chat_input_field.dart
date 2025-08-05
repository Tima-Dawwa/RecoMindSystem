import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String text, Uint8List? imageBytes) onSubmitted;
  final bool enabled; 

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.onSubmitted,
    this.enabled = true,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  Uint8List? _pickedImage;

  void _pickImage() async {
    if (!widget.enabled) return;

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

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  void _submit() {
    if (!widget.enabled) return;

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:
            widget.enabled ? Themes.bg.withAlpha(100) : Themes.bg.withAlpha(50),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Themes.bg.withAlpha(50), width: 1),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _pickedImage != null ? Icons.image : Icons.attach_file,
              color: widget.enabled ? Themes.bg : Themes.bg.withAlpha(100),
            ),
            onPressed: widget.enabled ? _pickImage : null,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: widget.controller,
                  enabled: widget.enabled,
                  style: TextStyle(
                    color:
                        widget.enabled
                            ? Themes.text
                            : Themes.text.withAlpha(100),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: widget.enabled ? (_) => _submit() : null,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText:
                        widget.enabled ? 'Ask anything...' : 'Connecting...',
                    hintStyle: TextStyle(color: Themes.bg.withAlpha(100)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),

                if (_pickedImage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Themes.bg.withAlpha(50)),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _pickedImage!,
                            height: 80,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _removeImage,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          if ((hasText || _pickedImage != null) && widget.enabled)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Themes.bg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
                onPressed: _submit,
              ),
            ),
        ],
      ),
    );
  }
}
