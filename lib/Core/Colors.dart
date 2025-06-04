import 'package:flutter/animation.dart';

class AppColors {
  static Color background = "#EBEBEB".toColor();
  static Color primary = "#4F00E2".toColor();
}

extension HexColor on String {
  Color toColor() {
    final hex = replaceAll('#', '');
    final buffer = StringBuffer();
    if (hex.length == 6)
      buffer.write('ff'); // add default alpha if not provided
    buffer.write(hex);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
