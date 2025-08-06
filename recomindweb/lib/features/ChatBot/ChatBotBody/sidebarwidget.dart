import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_cubit.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_status.dart';

class SidebarWidget extends StatefulWidget {
  final String? currentChatId;
  final Function(String?) onChatSelected;
  final Function() onNewChat;

  const SidebarWidget({
    Key? key,
    this.currentChatId,
    required this.onChatSelected,
    required this.onNewChat,
  }) : super(key: key);

  @override
  _SidebarWidgetState createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Use post frame callback to ensure the context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized && mounted) {
        _hasInitialized = true;
        context.read<ChatBotCubit>().getAllChats();
      }
    });
  }

  void _handleNewChat() async {
    try {
      final cubit = context.read<ChatBotCubit>();

      // Clear current chat and notify parent
      cubit.clearCurrentChat();
      widget.onNewChat();

      // Create new chat
      await cubit.creatChat();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating new chat: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Themes.text.withAlpha(225),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu, color: Themes.bg),
              IconButton(
                icon: Icon(Icons.search, color: Themes.bg),
                onPressed: () {
                  // TODO: Implement search functionality
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Themes.bg),
                onPressed: () {
                  // TODO: Implement delete functionality
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Create New Chat Button
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<ChatBotCubit, ChatBotStatus>(
              builder: (context, state) {
                final isLoading = state is LoadingChatBot;
                return ElevatedButton.icon(
                  onPressed: isLoading ? null : _handleNewChat,
                  icon:
                      isLoading
                          ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Themes.text,
                              ),
                            ),
                          )
                          : Icon(Icons.add, color: Themes.text),
                  label: Text(
                    isLoading ? 'Creating...' : 'New Chat',
                    style: TextStyle(color: Themes.text),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLoading ? Themes.bg.withOpacity(0.6) : Themes.bg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Chat List
          Expanded(
            child: BlocConsumer<ChatBotCubit, ChatBotStatus>(
              listener: (context, state) {
                if (state is ChatCreatedSuccessfully) {
                  // When a new chat is created successfully, select it
                  widget.onChatSelected(state.chatId);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('New chat created successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (state is FailureChatBot) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failure.errMessage),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final chatBotCubit = context.read<ChatBotCubit>();
                final chats = chatBotCubit.allChats;

                // Show loading only if we don't have any chats yet and we're loading
                if (state is LoadingChatBot && chats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Themes.bg),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading chats...',
                          style: TextStyle(
                            color: Themes.bg.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Show error state only if we don't have chats
                if (state is FailureChatBot && chats.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load chats',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.failure.errMessage,
                        style: TextStyle(color: Colors.red, fontSize: 10),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          context.read<ChatBotCubit>().getAllChats();
                        },
                        child: Text(
                          'Retry',
                          style: TextStyle(color: Themes.bg),
                        ),
                      ),
                    ],
                  );
                }

                // Show empty state if no chats
                if (chats.isEmpty && state is! LoadingChatBot) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Themes.bg.withOpacity(0.4),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No chats yet',
                          style: TextStyle(
                            color: Themes.bg.withOpacity(0.4),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create a new chat to get started',
                          style: TextStyle(
                            color: Themes.bg.withOpacity(0.3),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Show chat list
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with refresh option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Chats (${chats.length})",
                          style: TextStyle(
                            color: Themes.bg.withOpacity(0.4),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (state is! LoadingChatBot)
                          InkWell(
                            onTap:
                                () =>
                                    context.read<ChatBotCubit>().getAllChats(),
                            child: Icon(
                              Icons.refresh,
                              color: Themes.bg.withOpacity(0.4),
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Chat list
                    Expanded(
                      child: ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];
                          final isSelected = chat.id == widget.currentChatId;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  widget.onChatSelected(chat.id);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Themes.bg.withOpacity(0.2)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        isSelected
                                            ? Border.all(
                                              color: Themes.bg.withOpacity(0.4),
                                              width: 1,
                                            )
                                            : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.chat,
                                        color:
                                            isSelected
                                                ? Themes.bg
                                                : Themes.bg.withOpacity(0.6),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          chat.title.isNotEmpty
                                              ? chat.title
                                              : 'Chat ${index + 1}',
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Themes.bg
                                                    : Themes.bg.withOpacity(
                                                      0.8,
                                                    ),
                                            fontSize: 13,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.w500
                                                    : FontWeight.normal,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Themes.bg,
                                          size: 12,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
