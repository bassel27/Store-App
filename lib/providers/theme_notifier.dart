import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/constants.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode get currentThemeMode => _currentThemeMode;

  ThemeMode _currentThemeMode = ThemeMode.system;
  bool get isDarkMode =>
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(kThemePreferenceKey);
    if (savedThemeMode == 'dark') {
      _currentThemeMode = ThemeMode.dark;
    } else if (savedThemeMode == 'light') {
      _currentThemeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void toggleThemeMode(bool isDarkModeOn) async {
    _currentThemeMode = isDarkModeOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kThemePreferenceKey, isDarkModeOn ? 'dark' : 'light');
  }
}
