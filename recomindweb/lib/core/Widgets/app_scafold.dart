
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recomindweb/core/chat_controller.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/core/widgets/chatbot_floating_button.dart';
import 'package:recomindweb/features/ChatBot/chatbot.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  double _chatWidth = 350; 
  final double _minChatWidth = 250;
  final double _maxChatWidth = 600; 

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);

    return Scaffold(
      backgroundColor: Themes.bg,
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: widget.child,
                  ),
                ),
                const DraggableFloatingButton(),
              ],
            ),
          ),

          if (chatController.isChatOpen)
            Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: _chatWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300),
                    ),
                    color: Colors.white,
                  ),
                  child: const ChatWindow(),
                ),

                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _chatWidth -= details.delta.dx;
                        _chatWidth = _chatWidth.clamp(
                          _minChatWidth,
                          _maxChatWidth,
                        );
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeLeftRight,
                      child: Container(
                        width: 8,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
