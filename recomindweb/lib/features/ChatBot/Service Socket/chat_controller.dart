import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:recomindweb/features/ChatBot/Service%20Socket/socket_service.dart';

class ChatController extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  static const String TEST_CHAT_ID = "68923cd449b443251af1aec4";

  List<ChatMessage> _messages = [];
  bool _isConnected = false;
  bool _isBotTyping = false;
  String? _currentChatId;
  String? _errorMessage;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isConnected => _isConnected;
  bool get isBotTyping => _isBotTyping;
  String? get currentChatId => _currentChatId;
  String? get errorMessage => _errorMessage;
  bool get hasMessages => _messages.isNotEmpty;

  ChatController() {
    _initializeSocketService();
  }

  void _initializeSocketService() {
    _socketService.onChatHistory = _handleChatHistory;
    _socketService.onMessageSent = _handleMessageSent;
    _socketService.onMessageReceived = _handleMessageReceived;
    _socketService.onBotTyping = _handleBotTyping;
    _socketService.onError = _handleError;

    _socketService.onConnected = _handleConnected;
    _socketService.onDisconnected = _handleDisconnected;
  }

  Future<void> connectToServer(
    String serverUrl,
    String token, {
    Map<String, dynamic>? additionalQuery,
  }) async {
    try {
      _socketService.initializeWithAuth(
        serverUrl,
        token,
        additionalQuery: additionalQuery,
      );
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to connect to server: $e');
    }
  }

  Future<void> connectWithToken(
    String serverUrl,
    String token, {
    Map<String, dynamic>? additionalQuery,
  }) async {
    await connectToServer(serverUrl, token, additionalQuery: additionalQuery);
  }

  Future<void> connectAndJoinTestChat(
    String serverUrl,
    String token, {
    Map<String, dynamic>? additionalQuery,
  }) async {
    await connectToServer(serverUrl, token, additionalQuery: additionalQuery);
  }

  Future<void> connectWithTokenAndJoinTestChat(
    String serverUrl,
    String token, {
    Map<String, dynamic>? additionalQuery,
  }) async {
    await connectToServer(serverUrl, token, additionalQuery: additionalQuery);
  }

  Future<void> joinChat(String chatId) async {
    try {
      if (!_isConnected) {
        throw Exception('Not connected to server');
      }

      await _socketService.joinChat(chatId);
      _currentChatId = chatId;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to join chat: $e');
    }
  }

  void leaveChat() {
    _socketService.leaveChat();
    _currentChatId = null;
    _messages.clear();
    _isBotTyping = false;
    notifyListeners();
  }

  void sendMessage({String? text, Uint8List? imageBytes}) {
    if ((text == null || text.trim().isEmpty) && imageBytes == null) {
      _setError('Please enter a message or select an image');
      return;
    }

    final userMessage = ChatMessage.user(
      text: text?.trim(),
      imageBytes: imageBytes,
      timestamp: DateTime.now(),
    );

    _addMessage(userMessage);
    _socketService.sendMessage(message: text, imageBytes: imageBytes);
  }

  void sendTextMessage(String text) {
    sendMessage(text: text);
  }

  void sendImageMessage(Uint8List imageBytes) {
    sendMessage(imageBytes: imageBytes);
  }

  void sendTextWithImage(String text, Uint8List imageBytes) {
    sendMessage(text: text, imageBytes: imageBytes);
  }

  void _handleConnected() {
    print('🎉 Connection established, joining test chat...');
    _isConnected = true;
    notifyListeners();

    joinChat(TEST_CHAT_ID);
  }

  void _handleDisconnected() {
    print('💔 Connection lost');
    _isConnected = false;
    _currentChatId = null;
    notifyListeners();
  }

  void _handleChatHistory(List<ChatMessage> messages) {
    _messages = messages;
    _clearError();
    notifyListeners();
  }

  void _handleMessageSent(ChatMessage message) {
    _clearError();
  }

  void _handleMessageReceived(ChatMessage message) {
    _removeWaitingMessage();
    _addMessage(message);
  }

  void _handleBotTyping(bool isTyping) {
    _isBotTyping = isTyping;

    if (isTyping) {
      _addWaitingMessage();
    } else {
      _removeWaitingMessage();
    }

    notifyListeners();
  }

  void _handleError(String error) {
    _setError(error);
    _removeWaitingMessage();
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void _addWaitingMessage() {
    _removeWaitingMessage();
    _messages.add(ChatMessage.waiting());
    notifyListeners();
  }

  void _removeWaitingMessage() {
    _messages.removeWhere((msg) => msg.type == MessageType.waiting);
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  void onProductTap(Product product) {
    print('Product tapped: ${product.name}');
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }
}
