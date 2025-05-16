
import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.hint,
    this.type,
    this.obscure,
  });
  final String hint;
  final bool? obscure;
  final TextInputType? type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Themes.text, fontSize: 16),
      cursorRadius: Radius.circular(5),
      cursorColor: Themes.primary,
      cursorOpacityAnimates: true,
      keyboardType: type,
      obscureText: obscure ?? false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        filled: true,
        fillColor: Themes.bg.withAlpha(80),
        hintText: hint,
        hintStyle: TextStyle(color: Themes.text.withAlpha(120)),
        hintFadeDuration: Duration(milliseconds: 250),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: Themes.bg),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1.5, color: Themes.secondary),
        ),
      ),
    );
  }
}
