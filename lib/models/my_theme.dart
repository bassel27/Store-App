import 'package:flutter/material.dart';

// primaryColor2 over primaryColor
var kPrimaryColor = const Color(0xFF00478F);
var kPrimaryColor2 = Colors.white;
var kSecondaryColor = const Color(0xFFCBEBF5);
var kAccentColor = const Color(0xFF65DFF6);
const Color kBackgroundColor = Color.fromARGB(255, 233, 233, 233);
const TextStyle kBodySmallTestStyle =
    TextStyle(fontWeight: FontWeight.w700, fontSize: 16);

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
    colorScheme: const ColorScheme.light().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      background: kBackgroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: kAccentColor)),
    textTheme: TextTheme(
      bodySmall: kBodySmallTestStyle.copyWith(color: Colors.black),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kPrimaryColor,
      actionTextColor: kAccentColor,
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    textTheme: TextTheme(
      bodySmall: kBodySmallTestStyle.copyWith(
          color: Colors.white), // for productGridTile
    ),
  );
}
