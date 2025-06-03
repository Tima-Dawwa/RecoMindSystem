import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    this.type,
    this.obscure,
    this.validator,
    this.onSaved,
    this.hint,
    this.suffix,
    this.onChanged,
    this.onFieldSubmitted,
  });
  final String? hint;
  final bool? obscure;
  final TextInputType? type;
  final IconButton? suffix;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: type,
      cursorRadius: Radius.circular(5),
      cursorColor: Themes.primary,
      cursorOpacityAnimates: true,
      obscureText: obscure ?? false,
      style: TextStyle(color: Themes.text, fontSize: 16),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        suffixIcon: suffix,
        filled: true,
        hintText: hint,
        fillColor: Themes.bg.withAlpha(80),
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
          gapPadding: 1,
          borderSide: BorderSide(width: 1.5, color: Themes.secondary),
        ),
      ),
    );
  }
}
