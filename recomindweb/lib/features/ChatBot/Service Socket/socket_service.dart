import 'dart:convert';
import 'dart:typed_data';
import 'package:recomindweb/core/helpers/constant.dart';
import 'package:recomindweb/features/ChatBot/Model/chat_message.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  String? _currentChatId;

  Function(List<ChatMessage>)? onChatHistory;
  Function(ChatMessage)? onMessageSent;
  Function(ChatMessage)? onMessageReceived;
  Function(bool)? onBotTyping;
  Function(String)? onError;
  Function()? onConnected;
  Function()? onDisconnected;

  bool get isConnected => _socket?.connected ?? false;
  String? get currentChatId => _currentChatId;

  void initializeWithAuth({Map<String, dynamic>? additionalQuery}) {
    disconnect();

    final queryParams = <String, dynamic>{
      'token':
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRiYzJjMzE3NTZhZmIzOWJiZGZiM2NhOCIsIm5hbWUiOnsiZmlyc3RfbmFtZSI6IlJhbmRhbGwiLCJsYXN0X25hbWUiOiJCdWNrcmlkZ2UifSwiaWF0IjoxNzU2Nzk5MzU2LCJleHAiOjE3NTcwNTg1NTZ9.Eiv6dy4geSsg1VK94b6u3kuGRxC189yo__GUupQar2A",
      ...?additionalQuery,
    };

    _socket = IO.io(ngrok, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'enableReconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 1000,
      'query': queryParams,
    });

    _socket!.connect();
    _setupEventListeners();
  }

  void _setupEventListeners() {
    if (_socket == null) return;

    _socket!.on('connect', (_) {
      onConnected?.call();
    });

    _socket!.on('disconnect', (reason) {
      onDisconnected?.call();
    });

    _socket!.on('connect_error', (error) {
      onError?.call('Connection failed: $error');
    });

    _socket!.on('reconnect', (attemptNumber) {
      onConnected?.call();
    });

    _socket!.on('reconnect_error', (error) {
      onError?.call('Reconnection failed: $error');
    });

    _socket!.on('chat-history', (data) {
      try {
        final messages = _parseMessageHistory(data);
        onChatHistory?.call(messages);
      } catch (e) {
        onError?.call('Failed to load chat history');
      }
    });

    _socket!.on('message-sent', (data) {
      try {
        final message = _parseMessage(data);
        onMessageSent?.call(message);
      } catch (e) {
        print('Error parsing sent message: $e');
      }
    });

    _socket!.on('receive-message', (data) {
      print(data);
      try {
        final message = _parseMessage(data);
        onMessageReceived?.call(message);
      } catch (e) {
        onError?.call('Failed to receive message');
      }
    });

    _socket!.on('bot-typing', (data) {
      try {
        final isTyping = data is bool ? data : (data == true || data == 'true');
        onBotTyping?.call(isTyping);
      } catch (e) {
        print('Error parsing bot typing: $e');
      }
    });

    _socket!.on('chat-error', (data) {
      String error = 'Chat error occurred';
      if (data is Map<String, dynamic>) {
        error = data['message'] ?? error;
      } else if (data is String) {
        error = data;
      }
      onError?.call(error);
    });

    _socket!.on('message-error', (data) {
      String error = 'Message error occurred';
      if (data is Map<String, dynamic>) {
        error = data['message'] ?? error;
      } else if (data is String) {
        error = data;
      }
      onError?.call(error);
    });
  }

  Future<void> joinChat(String chatId) async {
    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket not connected');
    }

    _currentChatId = chatId;
    _socket!.emit('join-chat', chatId);
  }

  void leaveChat() {
    if (_socket == null) return;

    _socket!.emit('leave-chat');
    _currentChatId = null;
  }

  void sendMessage({String? message, Uint8List? imageBytes}) {
    if (_socket == null || !_socket!.connected) {
      onError?.call('Not connected to server');
      return;
    }

    if (_currentChatId == null) {
      onError?.call('No chat joined');
      return;
    }

    final data = <String, dynamic>{};

    if (message != null && message.trim().isNotEmpty) {
      data['message'] = message.trim();
    }

    if (imageBytes != null) {
      try {
        final base64Image = base64Encode(imageBytes);
        data['imageData'] = base64Image;
        data['hasImage'] = true;
      } catch (e) {
        onError?.call('Failed to encode image to base64: $e');
        return;
      }
    }

    if (data.isEmpty) {
      onError?.call('No content to send');
      return;
    }

    _socket!.emit('send-message', data);
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _currentChatId = null;
  }

  List<ChatMessage> _parseMessageHistory(dynamic data) {
    if (data == null) return [];

    try {
      final List<dynamic> messageList = data is List ? data : [data];
      return messageList
          .map((msgData) => _parseMessage(msgData))
          .where((msg) => msg.hasContent)
          .toList();
    } catch (e) {
      return [];
    }
  }

  ChatMessage _parseMessage(dynamic data) {
    if (data == null) {
      throw Exception('Message data is null');
    }

    final Map<String, dynamic> msgData =
        data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data);

    final senderType = msgData['senderType'] as String? ?? 'system';
    final fromMe = msgData['from_me'] as bool? ?? false;
    final isUser = fromMe || senderType == 'user';

    DateTime timestamp = DateTime.now();
    if (msgData['timestamp'] != null) {
      timestamp =
          DateTime.tryParse(msgData['timestamp'].toString()) ?? DateTime.now();
    }

    String? imagePath;

    if (msgData['imagePath'] != null) {
      imagePath = msgData['imagePath'].toString();
    } else if (msgData['image'] != null) {
      final imageData = msgData['image'];
      if (imageData is String) {
        if (imageData.startsWith('http') ||
            imageData.startsWith('/') ||
            imageData.contains('.png') ||
            imageData.contains('.jpg') ||
            imageData.contains('.jpeg')) {
          imagePath = imageData;
        } else {
          if (imageData.startsWith('data:image/') ||
              (imageData.length > 100 && !imageData.contains(' '))) {
            imagePath = imageData;
          }
        }
      }
    } else if (msgData['imageUrl'] != null) {
      imagePath = msgData['imageUrl'].toString();
    }

    return ChatMessage(
      type: isUser ? MessageType.user : MessageType.bot,
      text: msgData['content'] as String?,
      timestamp: timestamp,
      imagePath: imagePath,
      responseProducts: _parseProducts(msgData['recommendedProducts']),
    );
  }

  List<ProductModel>? _parseProducts(dynamic productsData) {
    if (productsData == null) return null;

    try {
      final List<dynamic> productList =
          productsData is List ? productsData : [productsData];

      return productList
          .where((item) => item != null)
          .map((productData) {
            try {
              if (productData is Map<String, dynamic>) {
                final mappedData = <String, dynamic>{
                  "id": productData['id'] ?? '',
                  'name': productData['name'] ?? '',
                  'imageUrl':
                      productData['image'] ?? productData['imageUrl'] ?? '',
                  'price': (productData['price'] ?? 0).toDouble(),
                  'discountPercent':
                      productData['is_discounted'] == true
                          ? ((productData['price'] -
                                      productData['discounted_price']) /
                                  productData['price'] *
                                  100)
                              .round()
                          : null,
                  'isFavorite': productData['isFavorite'] ?? false,
                  'gender': productData['gender'] ?? '',
                  'category':
                      productData['department'] ??
                      productData['category'] ??
                      '',
                  'isTrending': productData['isTrend'] ?? false,
                  'rating': (productData['rating'] ?? 0).toDouble(),
                  'tagType':
                      productData['isNew'] == true
                          ? 'new'
                          : (productData['isTrend'] == true ? 'trending' : ''),
                };

                return ProductModel.fromJson(mappedData);
              } else if (productData is String) {
                return null;
              } else {
                return ProductModel.fromJson(
                  Map<String, dynamic>.from(productData),
                );
              }
            } catch (e) {
              return null;
            }
          })
          .where((product) => product != null)
          .cast<ProductModel>()
          .toList();
    } catch (e) {
      return null;
    }
  }
}
