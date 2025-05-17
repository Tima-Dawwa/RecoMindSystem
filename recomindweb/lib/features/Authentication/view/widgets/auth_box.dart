import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class AuthBox extends StatelessWidget {
  const AuthBox({super.key, required this.content, required this.height, required this.width});
  final Widget content;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * height,
      width: MediaQuery.of(context).size.width * width,
      child: Container(
        margin: EdgeInsets.only(left: 80),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Themes.primary.withAlpha(80), blurRadius: 5),
          ],
        ),
        child: content,
      ),
    );
  }
}
