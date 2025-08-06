import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/helpers/failure.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatBot_services.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_status.dart';

class ChatBotCubit extends Cubit<ChatBotStatus> {
  final ChatBotService chatBotService;

  ChatBotCubit(this.chatBotService) : super(InitialChatBot());

  List<String> allChats = [];

  Future<void> getAllChats({required String productId}) async {
    emit(LoadingChatBot());

    final result = await chatBotService.getAllChats();

    result.fold(
      (failure) {
        emit(FailureChatBot(failure: failure));
      },
      (data) {
        try {
          final chatList = data['data'];
          allChats = List<String>.from(chatList);
          emit(SuccessChatBot());
        } catch (e) {
          emit(
            FailureChatBot(
              failure: Failure(
                errTitle: "Parsing Error",
                errMessage: e.toString(),
              ),
            ),
          );
        }
      },
    );
  }
  
  Future<void> creatChat({required String productId}) async {
    emit(LoadingChatBot());

    final result = await chatBotService.creatChat();

    result.fold(
      (failure) {
        emit(FailureChatBot(failure: failure));
      },
      (data) {
        try {
          emit(SuccessChatBot());
        } catch (e) {
          emit(
            FailureChatBot(
              failure: Failure(
                errTitle: "Parsing Error",
                errMessage: e.toString(),
              ),
            ),
          );
        }
      },
    );
  }
}
