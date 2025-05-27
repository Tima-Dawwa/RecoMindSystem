import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.textColor,
    required this.text,
    required this.press,
  });
  final double? height;
  final double? width;
  final WidgetStateProperty<Color?>? color;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final String text;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: press,
        style: ButtonStyle(
          backgroundColor: color ?? WidgetStatePropertyAll(Themes.primary),
          overlayColor: WidgetStatePropertyAll(Themes.bg.withAlpha(10)),
          animationDuration: Duration(microseconds: 4000),
          // elevation: WidgetStatePropertyAll(2),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              side: BorderSide(
                width: 2,
                color: borderColor ?? Colors.transparent,
              ),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor ?? Themes.bg, fontSize: 20),
        ),
      ),
    );
  }
}
