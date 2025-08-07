import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:recomindweb/features/ChatBot/Service%20Socket/socket_service.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatBot_services.dart';

class ChatController extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  List<ChatMessage> _messages = [];
  bool _isConnected = false;
  bool _isBotTyping = false;
  String? _currentChatId;
  String? _errorMessage;
  bool _isCreatingChat = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isConnected => _isConnected;
  bool get isBotTyping => _isBotTyping;
  String? get currentChatId => _currentChatId;
  String? get errorMessage => _errorMessage;
  bool get hasMessages => _messages.isNotEmpty;
  bool get isCreatingChat => _isCreatingChat;

  Function(String)? onChatCreated;

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
     {
    Map<String, dynamic>? additionalQuery,
  }) async {
    try {
      _socketService.initializeWithAuth(
        
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
    await connectToServer( additionalQuery: additionalQuery);
  }

  Future<void> connectAndJoinTestChat(
    String serverUrl,
    String token, {
    Map<String, dynamic>? additionalQuery,
  }) async {
    await connectToServer( additionalQuery: additionalQuery);
  }

  Future<void> connectWithTokenAndJoinTestChat(
    String serverUrl,
    String token, {
    Map<String, dynamic>? additionalQuery,
  }) async {
    await connectToServer( additionalQuery: additionalQuery);
  }

  static ChatBotService? _chatBotService;

  static void setChatBotService(ChatBotService chatBotService) {
    _chatBotService = chatBotService;
  }

  Future<String?> createNewChat() async {
    if (!_isConnected) {
      _setError('Not connected to server');
      return null;
    }

    if (_isCreatingChat) {
      return null; 
    }

    if (_chatBotService == null) {
      _setError('ChatBot service not initialized');
      return null;
    }

    try {
      _isCreatingChat = true;
      notifyListeners();

   
      final result = await _chatBotService!.creatChat();

      return result.fold(
        (failure) {
          _setError('Failed to create chat: ${failure.errMessage}');
          return null;
        },
        (data) {
          String? newChatId;
          if (data['chatID'] != null) {
            newChatId = data['chatID'].toString();
          }

          if (newChatId != null && newChatId.isNotEmpty) {
            _currentChatId = newChatId;
            _clearError();

           
            onChatCreated?.call(newChatId);

            return newChatId;
          } else {
            _setError('Chat created but no chat ID returned from server');
            return null;
          }
        },
      );
    } catch (e) {
      _setError('Failed to create chat: $e');
      return null;
    } finally {
      _isCreatingChat = false;
      notifyListeners();
    }
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

  Future<void> sendMessage({String? text, Uint8List? imageBytes}) async {
    if ((text == null || text.trim().isEmpty) && imageBytes == null) {
      _setError('Please enter a message or select an image');
      return;
    }

    if (_currentChatId == null) {
      final newChatId = await createNewChat();
      if (newChatId == null) {
        return; 
      }

      await joinChat(newChatId);
    }

    final userMessage = ChatMessage.user(
      text: text?.trim(),
      imageBytes: imageBytes,
      timestamp: DateTime.now(),
    );

    _addMessage(userMessage);
    _socketService.sendMessage(message: text, imageBytes: imageBytes);
  }

  void sendTextMessage(String text) async {
    await sendMessage(text: text);
  }

  void sendImageMessage(Uint8List imageBytes) async {
    await sendMessage(imageBytes: imageBytes);
  }

  void sendTextWithImage(String text, Uint8List imageBytes) async {
    await sendMessage(text: text, imageBytes: imageBytes);
  }

  void _handleConnected() {
    _isConnected = true;
    notifyListeners();
  }

  void _handleDisconnected() {
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

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  Future<void> switchToChat(String chatId) async {
    clearMessages();
    await joinChat(chatId);
  }

  Future<void> leaveCurrentChat() async {
    clearMessages();
  }

  void setCurrentChatId(String? chatId) {
    if (_currentChatId != chatId) {
      _currentChatId = chatId;
      clearMessages();
      notifyListeners();

      if (chatId != null) {
        joinChat(chatId);
      }
    }
  }
}
