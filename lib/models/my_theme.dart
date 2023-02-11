import 'package:flutter/material.dart';

// primaryColor2 over primaryColor
var kPrimaryColor = const Color(0xFFF8F8F8);
var kSecondaryColor = Colors.black;
var kAccentColor = Colors.red;
const TextStyle kBodySmallTestStyle =
    TextStyle(fontWeight: FontWeight.w700, fontSize: 16);

class MyTheme {
  static final lightTheme = ThemeData(
    iconTheme: IconThemeData(color: kAccentColor),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: kSecondaryColor),
    appBarTheme: AppBarTheme(
      color: kPrimaryColor,
      iconTheme: IconThemeData(color: kAccentColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kPrimaryColor,
        selectedItemColor: kAccentColor,
        unselectedItemColor: kSecondaryColor),
    colorScheme: const ColorScheme.light().copyWith(
        background: kPrimaryColor,
        primary: kSecondaryColor,
        secondary: kAccentColor,
        onPrimary: Colors.black),
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
