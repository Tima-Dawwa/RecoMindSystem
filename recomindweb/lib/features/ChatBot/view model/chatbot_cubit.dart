import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/features/ChatBot/Model/allchat_model.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatBot_services.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_status.dart';

class ChatBotCubit extends Cubit<ChatBotStatus> {
  final ChatBotService chatBotService;

  ChatBotCubit(this.chatBotService) : super(InitialChatBot());

  List<AllchatModel> allChats = [];
  String? currentChatId;

  Future<void> getAllChats() async {
    emit(LoadingChatBot());

    final result = await chatBotService.getAllChats();

    result.fold(
      (failure) {
        emit(FailureChatBot(failure: failure));
      },
      (data) {
        try {
          List<dynamic> chatList;
          if (data['data'] is List) {
            chatList = data['data'];
          } else {
            chatList = [];
          }

          allChats =
              chatList.map((chatJson) {
                return AllchatModel.fromJson(chatJson as Map<String, dynamic>);
              }).toList();

          emit(SuccessChatBot());
        } catch (e) {
          emit(
            FailureChatBot(
              failure: Failure(
                errTitle: "Parsing Error",
                errMessage: "Failed to parse chats: ${e.toString()}",
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> creatChat({String? productId}) async {
    emit(LoadingChatBot());

    final result = await chatBotService.creatChat();

    result.fold(
      (failure) {
        emit(FailureChatBot(failure: failure));
      },
      (data) {
        try {
          String? newChatId;

          if (data['chatID'] != null) {
            newChatId = data['chatID'].toString();
          }

          if (newChatId != null && newChatId.isNotEmpty) {
            final newChat = AllchatModel(id: newChatId, title: "New Chat");

            if (!allChats.any((chat) => chat.id == newChatId)) {
              allChats.insert(0, newChat);
            }
            currentChatId = newChatId;
            emit(ChatCreatedSuccessfully(chatId: newChatId));
          } else {
            emit(
              FailureChatBot(
                failure: Failure(
                  errTitle: "Chat Creation Error",
                  errMessage:
                      "Chat created but no chat ID returned from server",
                ),
              ),
            );
          }
        } catch (e) {
          emit(
            FailureChatBot(
              failure: Failure(
                errTitle: "Chat Creation Error",
                errMessage: "Failed to create chat: ${e.toString()}",
              ),
            ),
          );
        }
      },
    );
  }

  void setCurrentChat(String? chatId) {
    currentChatId = chatId;
  }

  void clearCurrentChat() {
    currentChatId = null;
  }

  Future<void> removeFromFavorites(String productId) async {
    emit(RemoveFavouritesLoadingState());

    final result = await chatBotService.removeFromFavourites(
      favoriteId: productId,
    );

    result.fold(
      (failure) => emit(FailureChatBot(failure: failure)),
      (_) => emit(
        FavoritesUpdatedSuccessfully(productId: productId, isFavorite: false),
      ),
    );
  }

  Future<void> addToFavorites(String productId) async {
    emit(AddFavouritesLoadingState());

    final result = await chatBotService.addToFavorites(productId: productId);

    result.fold(
      (failure) => emit(FailureChatBot(failure: failure)),
      (_) => emit(
        FavoritesUpdatedSuccessfully(productId: productId, isFavorite: true),
      ),
    );
  }
}
