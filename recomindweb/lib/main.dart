import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';
import 'package:recomindweb/core/chat_controller.dart';
import 'package:recomindweb/core/go_router.dart';
import 'package:recomindweb/core/theme.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatController(),
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Trendova',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Themes.primary,
          fontFamily: 'CoconNext',
          scaffoldBackgroundColor: Themes.bg,
        ),
      ),
    );
  }
}
