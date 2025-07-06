import 'package:dashboard/core/utils/theme.dart';
import 'package:flutter/material.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page', style: TextStyle(color: Themes.bg)),
        backgroundColor: Themes.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64, color: Themes.bg),
            SizedBox(height: 16),
            Text(
              'Main Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Welcome to the main page of your application'),
          ],
        ),
      ),
    );
  }
}
