import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromRGBO(136, 14, 79, 0.8);
  const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  const errorColor = Color.fromRGBO(255, 0, 0, 0.2);

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    errorColor: errorColor,
    backgroundColor: Colors.black,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: primaryColorDark,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: primaryColorDark,
      titleTextStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColorLight,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: errorColor,
        ),
      ),
      alignLabelWithHint: true,
      labelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: primaryColorDark,
      ),
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: const ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 20,
        backgroundColor: primaryColorDark,
        shadowColor: primaryColorDark,
        visualDensity: VisualDensity.comfortable,
        animationDuration: const Duration(milliseconds: 500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColorLight,
      elevation: 30,
      splashColor: primaryColorDark,
    ),
  );
}
