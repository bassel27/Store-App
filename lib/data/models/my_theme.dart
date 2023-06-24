import 'package:flutter/material.dart';

// primaryColor2 over primaryColor
const kLightBackgroundColor = Color(0xFFF2F2F3);
const kLightPrimaryColor = Colors.white;
const kLightSecondaryColor = Color(0xFF8B8B94);
const kLightAccentColor = Color(0xFFF39D1A);
const kTextDarkColor = Colors.black;
const kTextLightColor = Colors.white;
const TextStyle kBodyText1Style =
    TextStyle(fontWeight: FontWeight.w700, fontSize: 16);
const kInactiveColor = kLightSecondaryColor;
const kActiveColor = kLightAccentColor;
const Color kErrorColor = Color(0xFFb30c2b);

const kDarkBackgroundColor = Colors.grey;
const kDarkPrimaryColor = Color.fromARGB(255, 125, 125, 125);
const kDarkSecondaryColor = Color.fromARGB(255, 181, 181, 184);
const kDarkAccentColor = Color(0xFFF39D1A);

class MyTheme {
  static final lightTheme = ThemeData(
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: kLightAccentColor),
    scaffoldBackgroundColor: kLightBackgroundColor,
    iconTheme: const IconThemeData(color: kLightAccentColor),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: kLightAccentColor),
    appBarTheme: const AppBarTheme(
      color: kLightBackgroundColor,
      iconTheme: IconThemeData(color: kLightAccentColor),
    ),
    // for text firelds
    inputDecorationTheme: const InputDecorationTheme(
      errorStyle: TextStyle(fontWeight: FontWeight.w400, color: kErrorColor),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kLightAccentColor),
      ),
      labelStyle: TextStyle(color: kTextDarkColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kLightAccentColor,
      selectionColor: kLightAccentColor,
      selectionHandleColor: kLightAccentColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kLightBackgroundColor,
        selectedItemColor: kLightAccentColor,
        unselectedItemColor: kLightSecondaryColor),
    colorScheme: const ColorScheme.light().copyWith(
        background: kLightBackgroundColor,
        primary: kLightPrimaryColor,
        secondary: kLightSecondaryColor,
        tertiary: kLightAccentColor,
        onBackground: Colors.black,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onTertiary: Colors.white),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: kLightAccentColor,
            textStyle: const TextStyle(color: kLightAccentColor))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: kLightAccentColor, foregroundColor: Colors.white)),
    textTheme: TextTheme(
        bodyText2: kBodyText1Style.copyWith(
            color: Colors.black,
            fontWeight: FontWeight
                .w500), // controls price, title and currency witth each copying with
        button: const TextStyle(color: kLightPrimaryColor)),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kLightPrimaryColor,
      actionTextColor: kTextDarkColor,
    ),
  );

  static final darkTheme = ThemeData(
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: kDarkAccentColor),
    scaffoldBackgroundColor: kDarkBackgroundColor,
    iconTheme: const IconThemeData(color: kDarkAccentColor),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: kDarkAccentColor),
    appBarTheme: const AppBarTheme(
      color: kDarkBackgroundColor,
      iconTheme: IconThemeData(color: kDarkAccentColor),
    ),
    // for text firelds
    inputDecorationTheme: const InputDecorationTheme(
      errorStyle: TextStyle(fontWeight: FontWeight.w400, color: kErrorColor),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kDarkAccentColor),
      ),
      labelStyle: TextStyle(color: kTextDarkColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kDarkAccentColor,
      selectionColor: kDarkAccentColor,
      selectionHandleColor: kDarkAccentColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kDarkBackgroundColor,
        selectedItemColor: kDarkAccentColor,
        unselectedItemColor: kDarkSecondaryColor),
    colorScheme: const ColorScheme.dark().copyWith(
        background: kDarkBackgroundColor,
        primary: kDarkPrimaryColor,
        secondary: kDarkSecondaryColor,
        tertiary: kDarkAccentColor,
        onBackground: Colors.black,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onTertiary: Colors.white),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: kDarkAccentColor,
            textStyle: const TextStyle(color: kDarkAccentColor))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: kDarkAccentColor, foregroundColor: Colors.white)),
    textTheme: TextTheme(
        bodyText2: kBodyText1Style.copyWith(
            color: Colors.black,
            fontWeight: FontWeight
                .w500), // controls price, title and currency witth each copying with
        button: const TextStyle(color: kDarkPrimaryColor)),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kDarkPrimaryColor,
      actionTextColor: kTextDarkColor,
    ),
  );
}
