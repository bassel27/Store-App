import 'package:flutter/material.dart';

// primaryColor2 over primaryColor
var kPrimaryColor = Color(0xFF00478F);
var kPrimaryColor2 = Colors.white;
var kSecondaryColor = Color(0xFFCBEBF5);
var kAccentColor = Color(0xFF65DFF6);

class MyTheme {
  static final lightTheme = ThemeData(
    iconTheme: IconThemeData(color: kAccentColor),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: kSecondaryColor),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: kAccentColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kPrimaryColor,
        selectedItemColor: kAccentColor,
        unselectedItemColor: kPrimaryColor2),
    colorScheme: ColorScheme.light().copyWith(
      primary: kPrimaryColor,
      onPrimary: kPrimaryColor2,
      secondary: kSecondaryColor,
      background: Colors.green,
      tertiary: Colors.amber,
      surface: Colors.lime,
    ),
  );
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(),
  );
}
