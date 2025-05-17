import 'package:flutter/material.dart';

import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/core/widgets/chatbot_floating_button.dart';


class AppScaffold extends StatefulWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
