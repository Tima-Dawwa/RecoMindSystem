import 'package:recomindweb/core/helpers/failure.dart';

abstract class ChatBotStatus {}

class InitialChatBot extends ChatBotStatus {}

class LoadingChatBot extends ChatBotStatus {}

class SuccessChatBot extends ChatBotStatus {}

class RemoveFavouritesLoadingState extends ChatBotStatus {}

class AddFavouritesLoadingState extends ChatBotStatus {}

class FavoritesUpdatedSuccessfully extends ChatBotStatus {
  final String productId;
  final bool isFavorite;

  FavoritesUpdatedSuccessfully({
    required this.productId,
    required this.isFavorite,
  });
}

class ChatCreatedSuccessfully extends ChatBotStatus {
  final String chatId;

  ChatCreatedSuccessfully({required this.chatId});
}

class FailureChatBot extends ChatBotStatus {
  final Failure failure;

  FailureChatBot({required this.failure});
}
