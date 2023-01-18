import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode currentThemeMode = ThemeMode.system;

  bool get isDarkMode =>
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  void toggleThemeMode(bool isDarkModeOn) {
    currentThemeMode = isDarkModeOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
