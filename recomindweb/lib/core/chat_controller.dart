import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  bool _isChatOpen = false;
  bool get isChatOpen => _isChatOpen;

  void toggleChat() {
    _isChatOpen = !_isChatOpen;
    notifyListeners();
  }

  void closeChat() {
    _isChatOpen = false;
    notifyListeners();
  }
}
