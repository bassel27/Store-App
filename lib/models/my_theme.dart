import 'package:flutter/material.dart';

// primaryColor2 over primaryColor
var kBackgroundColor = const Color(0xFFF8F8F8);
var kPrimaryColor = Colors.white;
var kSecondaryColor = const Color(0xFF8B8B94);
var kAccentColor = const Color(0xFFF39D1A);
var kTextColor = Colors.black;
const TextStyle kBodyText1Style =
    TextStyle(fontWeight: FontWeight.w700, fontSize: 16);

class MyTheme {
  static final lightTheme = ThemeData(
    iconTheme: IconThemeData(color: kAccentColor),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: kSecondaryColor),
    appBarTheme: AppBarTheme(
      color: kBackgroundColor,
      iconTheme: IconThemeData(color: kAccentColor),
    ),
    // for text firelds
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kAccentColor),
      ),
      labelStyle: TextStyle(color: kTextColor),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: kAccentColor,
      selectionColor: kAccentColor,
      selectionHandleColor: kAccentColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kBackgroundColor,
        selectedItemColor: kAccentColor,
        unselectedItemColor: kSecondaryColor),
    colorScheme: const ColorScheme.light().copyWith(
        background: kBackgroundColor,
        primary: kPrimaryColor,
        secondary: kSecondaryColor,
        tertiary: kAccentColor,
        onPrimary: Colors.black,
        onBackground: Colors.black,
        onTertiary: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: kAccentColor)),
    textTheme: TextTheme(
        bodyText1: kBodyText1Style.copyWith(color: Colors.black),
        button: TextStyle(color: kPrimaryColor)),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kPrimaryColor,
      actionTextColor: kAccentColor,
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    textTheme: const TextTheme(),
  );
}
