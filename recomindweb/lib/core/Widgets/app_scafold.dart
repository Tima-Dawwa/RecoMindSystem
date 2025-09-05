import 'package:flutter/material.dart';

import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/core/widgets/chatbot_floating_button.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final bool addPadding;

  const AppScaffold({super.key, required this.body, this.addPadding = true});
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
                    padding:
                        widget.addPadding
                            ? EdgeInsets.all(16)
                            : EdgeInsets.zero,
                    child: widget.body,
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
