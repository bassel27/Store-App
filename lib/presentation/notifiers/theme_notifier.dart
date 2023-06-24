import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/data/models/constants.dart';



class ThemeNotifier extends ChangeNotifier {
  ThemeMode get currentThemeMode => _currentThemeMode;

  late ThemeMode _currentThemeMode;
  bool get isDarkMode => _currentThemeMode == ThemeMode.dark;

  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(kThemePreferenceKey);
    if (savedThemeMode == 'dark') {
      _currentThemeMode = ThemeMode.dark;
    } else if (savedThemeMode == 'light') {
      _currentThemeMode = ThemeMode.light;
    } else {
      WidgetsBinding.instance.window.platformBrightness == Brightness.dark
          ? _currentThemeMode = ThemeMode.dark
          : _currentThemeMode = ThemeMode.light;
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
