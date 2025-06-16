import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.color,
    this.weight,
    this.size,
    required this.text,
    required this.press,
  });
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;
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
          fontSize: size ?? 14,
          fontWeight: weight ?? FontWeight.bold,
        ),
      ),
    );
  }
}
