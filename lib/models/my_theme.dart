import 'package:flutter/material.dart';

// primaryColor2 over primaryColor
const kBackgroundColor = Color(0xFFF2F2F3);
const kPrimaryColor = Colors.white;
const kSecondaryColor = Color(0xFF8B8B94);
const kAccentColor = Color(0xFFF39D1A);
const kTextDarkColor = Colors.black;
const kTextLightColor = Colors.white;
const TextStyle kBodyText1Style =
    TextStyle(fontWeight: FontWeight.w700, fontSize: 16);
const kInactiveColor = kSecondaryColor;
const kActiveColor = kAccentColor;
const Color kErrorColor = Color(0xFFb30c2b);

class MyTheme {
  static final lightTheme = ThemeData(
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: kAccentColor),
    scaffoldBackgroundColor: kBackgroundColor,
    iconTheme: const IconThemeData(color: kAccentColor),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: kAccentColor),
    appBarTheme: const AppBarTheme(
      color: kBackgroundColor,
      iconTheme: IconThemeData(color: kAccentColor),
    ),
    // for text firelds
    inputDecorationTheme: const InputDecorationTheme(
      errorStyle: TextStyle(fontWeight: FontWeight.w400, color: kErrorColor),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kAccentColor),
      ),
      labelStyle: TextStyle(color: kTextDarkColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kAccentColor,
      selectionColor: kAccentColor,
      selectionHandleColor: kAccentColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kBackgroundColor,
        selectedItemColor: kAccentColor,
        unselectedItemColor: kSecondaryColor),
    colorScheme: const ColorScheme.light().copyWith(
        background: kBackgroundColor,
        primary: kPrimaryColor,
        secondary: kSecondaryColor,
        tertiary: kAccentColor,
        onBackground: Colors.black,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onTertiary: Colors.white),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: kAccentColor,
            textStyle: const TextStyle(color: kAccentColor))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: kAccentColor, foregroundColor: Colors.white)),
    textTheme: TextTheme(
        bodyText2: kBodyText1Style.copyWith(
            color: Colors.black,
            fontWeight: FontWeight
                .w500), // controls price, title and currency witth each copying with
        button: const TextStyle(color: kPrimaryColor)),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kPrimaryColor,
      actionTextColor: kTextDarkColor,
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    textTheme: const TextTheme(),
  );
}
