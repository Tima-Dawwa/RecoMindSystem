import 'dart:ui';

import 'package:flutter/widgets.dart';

class Themes {
  static Color primary = const Color(0xff45007a);
  static Color secondary = const Color(0xffb8001c);
  static Color bg = const Color(0xFFFBF5FF);
  static Color text = const Color(0xff220135);

  Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

}
