import 'dart:convert';
import 'dart:typed_data';
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

  void initialize(String serverUrl, {Map<String, dynamic>? queryParameters}) {
    disconnect();

    print('Initializing socket connection to: $serverUrl');
    if (queryParameters != null) {
      print('Query parameters: $queryParameters');
    }

    _socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'enableReconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 1000,
      'query': queryParameters ?? {},
    });

    _socket!.connect();

    _setupEventListeners();
  }

  void initializeWithAuth(
    String serverUrl,
    String token, {
    Map<String, dynamic>? additionalQuery,
  }) {
    final queryParams = <String, dynamic>{'token': token, ...?additionalQuery};

    initialize(serverUrl, queryParameters: queryParams);
  }

  void _setupEventListeners() {
    if (_socket == null) return;

    _socket!.on('connect', (_) {
      print('✅ Connected to server');
      onConnected?.call();
    });

    _socket!.on('disconnect', (reason) {
      print('❌ Disconnected from server: $reason');
      onDisconnected?.call();
    });

    _socket!.on('connect_error', (error) {
      print('🔥 Connection error: $error');
      onError?.call('Connection failed: $error');
    });

    _socket!.on('reconnect', (attemptNumber) {
      print('🔄 Reconnected after $attemptNumber attempts');
      onConnected?.call();
    });

    _socket!.on('reconnect_error', (error) {
      print('🔥 Reconnection error: $error');
      onError?.call('Reconnection failed: $error');
    });

    _socket!.on('chat-history', (data) {
      print('📜 Received chat history');
      try {
        final messages = _parseMessageHistory(data);
        onChatHistory?.call(messages);
      } catch (e) {
        print('Error parsing chat history: $e');
        onError?.call('Failed to load chat history');
      }
    });

    _socket!.on('message-sent', (data) {
      print('✉️ Message sent confirmation');
      try {
        final message = _parseMessage(data);
        onMessageSent?.call(message);
      } catch (e) {
        print('Error parsing sent message: $e');
      }
    });

    _socket!.on('receive-message', (data) {
      print('📨 Received message from bot');
      try {
        final message = _parseMessage(data);
        onMessageReceived?.call(message);
      } catch (e) {
        print('Error parsing received message: $e');
        onError?.call('Failed to receive message');
      }
    });

    _socket!.on('bot-typing', (data) {
      print('⌨️ Bot typing status: $data');
      try {
        final isTyping = data is bool ? data : (data == true || data == 'true');
        onBotTyping?.call(isTyping);
      } catch (e) {
        print('Error parsing bot typing: $e');
      }
    });

    _socket!.on('chat-error', (data) {
      print('🔥 Chat error: $data');
      String error = 'Chat error occurred';
      if (data is Map<String, dynamic>) {
        error = data['message'] ?? error;
      } else if (data is String) {
        error = data;
      }
      onError?.call(error);
    });

    _socket!.on('message-error', (data) {
      print('🔥 Message error: $data');
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

    print('🏠 Joining chat: $chatId');
    _currentChatId = chatId;
    _socket!.emit('join-chat', chatId);
  }

  void leaveChat() {
    if (_socket == null) return;

    print('🚪 Leaving current chat');
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

    // Send image as Uint8List (binary data)
    if (imageBytes != null) {
      try {
        // Send the raw bytes directly without base64 encoding
        data['imageData'] = imageBytes;
        data['hasImage'] = true;
        print('📷 Sending image as binary data (${imageBytes.length} bytes)');
      } catch (e) {
        print('Error preparing image data: $e');
        onError?.call('Failed to prepare image');
        return;
      }
    }

    if (data.isEmpty) {
      onError?.call('No content to send');
      return;
    }

    print('📤 Sending message: ${data.keys.join(', ')}');
    _socket!.emit('send-message', data);
  }

  void disconnect() {
    if (_socket != null) {
      print('🔌 Disconnecting socket');
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
      print('Error parsing message history: $e');
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
      print('📷 Received image path: $imagePath');
    } else if (msgData['image'] != null) {
      final imageData = msgData['image'];
      if (imageData is String) {
        if (imageData.startsWith('http') ||
            imageData.startsWith('/') ||
            imageData.contains('.png') ||
            imageData.contains('.jpg') ||
            imageData.contains('.jpeg')) {
          imagePath = imageData;
          print('📷 Received image URL/path: $imagePath');
        } else {
          print('📷 Received base64 image data, skipping...');
        }
      }
    } else if (msgData['imageUrl'] != null) {
      imagePath = msgData['imageUrl'].toString();
      print('📷 Received image URL: $imagePath');
    }

    return ChatMessage(
      type: isUser ? MessageType.user : MessageType.bot,
      text: msgData['content'] as String?,
      timestamp: timestamp,
      imagePath: imagePath,
      responseProducts: _parseProducts(msgData['recommendedProducts']),
    );
  }

  List<Product>? _parseProducts(dynamic productsData) {
    if (productsData == null) return null;

    try {
      final List<dynamic> productList =
          productsData is List ? productsData : [productsData];

      return productList
          .where((item) => item != null)
          .map((productData) {
            try {
              // Check if productData is a Map (valid product object)
              if (productData is Map<String, dynamic>) {
                // Map the server response fields to the expected Product fields
                final mappedData = <String, dynamic>{
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

                return Product.fromJson(mappedData);
              } else if (productData is String) {
                // If it's just a string (like an ID), skip it and log
                print(
                  'Skipping product data - received ID instead of object: $productData',
                );
                return null;
              } else {
                // Try to convert other types to Map
                return Product.fromJson(Map<String, dynamic>.from(productData));
              }
            } catch (e) {
              print('Error parsing individual product: $e');
              print('Product data type: ${productData.runtimeType}');
              print('Product data: $productData');
              return null;
            }
          })
          .where((product) => product != null)
          .cast<Product>()
          .toList();
    } catch (e) {
      print('Error parsing products: $e');
      return null;
    }
  }

  void reconnect() {
    if (_socket != null) {
      _socket!.connect();
    }
  }

  void forceReconnect() {
    disconnect();
  }
}
