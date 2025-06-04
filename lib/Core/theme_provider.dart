import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;
  bool checkBox1 = false;
  bool checkBox2 = false;

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }

  void setCheckBox1(bool? value) {
    checkBox1 = value ?? false;
    notifyListeners();
  }

  void setCheckBox2(bool? value) {
    checkBox2 = value ?? false;
    notifyListeners();
  }
}
