import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.height, this.width, required this.text});
  final double? height;
  final double? width;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Themes.primary),
          overlayColor: WidgetStatePropertyAll(Themes.text.withAlpha(50)),
          animationDuration: Duration(microseconds: 4000),
          elevation: WidgetStatePropertyAll(2),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: Text(text, style: TextStyle(color: Themes.bg, fontSize: 20)),
      ),
    );
  }
}
