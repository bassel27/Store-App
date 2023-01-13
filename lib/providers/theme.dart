import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleThemeMode(bool isDarkModeOn) {
    themeMode = isDarkModeOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(),
  );
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(),
  );
}
