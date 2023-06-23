import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/constants.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode currentThemeMode = ThemeMode.system;
  bool get isDarkMode => currentThemeMode == ThemeMode.dark;

  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(kThemePreferenceKey);
    if (savedThemeMode == 'dark') {
      currentThemeMode = ThemeMode.dark;
    } else if (savedThemeMode == 'light') {
      currentThemeMode = ThemeMode.light;
    } else {
      currentThemeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void toggleThemeMode(bool isDarkModeOn) async {
    currentThemeMode = isDarkModeOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kThemePreferenceKey, isDarkModeOn ? 'dark' : 'light');
  }
}
