import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.color,
    required this.text,
    required this.press, this.weight,
  });
  final Color? color;
  final FontWeight? weight;
  final String text;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.only(left: 5)),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        alignment: Alignment.centerLeft,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color ?? Themes.text,
          fontSize: 14,
          fontWeight: weight ?? FontWeight.bold,
        ),
      ),
    );
  }
}
