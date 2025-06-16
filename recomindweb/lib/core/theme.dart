import 'package:flutter/material.dart';

class Themes {
  static Color primary = const Color(0xff45007a);
  static Color secondary = const Color(0xffb8001c);
  static Color third = const Color(0xffffd112);
  static Color bg = const Color(0xFFFBF5FF);
  static Color text = const Color(0xff220135);

  Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

static Future<DateTime?> customDatePicker({required BuildContext context}) async {
    return await showDatePicker(
      context: context,
      helpText: "Selected date",
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2026),
      builder: (context, widget) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Themes.primary,
            colorScheme: ColorScheme.light(
              primary: Themes.primary,
              onPrimary: Themes.bg,
              background: Themes.bg,
              surface: Themes.bg,
              onSurface: Themes.text,
              outline: Themes.text,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Themes.primary,
                backgroundColor: Themes.bg,
              ),
            ),
          ),
          child: widget!,
        );
      },
    );
  }
}
