import 'package:flutter/material.dart';

import 'colors.dart';

var lightTheme = ThemeData(
  brightness: Brightness.light,
  inputDecorationTheme: InputDecorationTheme(
    fillColor: containerColor,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    hintStyle: const TextStyle(
      fontSize: 15,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w400,
      color: labelColor,
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    background: bgColor,
    onBackground: fontColor,
    primaryContainer: containerColor,
    onPrimary: labelColor,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(
      fontSize: 15,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w400,
      color: labelColor,
    ),
  ),
);

var darkTheme = ThemeData(
  brightness: Brightness.dark,
  inputDecorationTheme: InputDecorationTheme(
    fillColor: containerColor,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    hintStyle: const TextStyle(
      fontSize: 15,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w400,
      color: labelColor,
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: primaryColorDark,
    secondary: secondaryColorDark,
    background: bgColorDark,
    onBackground: fontColorDark,
    primaryContainer: containerColorDark,
    onPrimary: labelColorDark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontFamily: "OldschoolGrotesk",
      fontWeight: FontWeight.w400,
    ),
  ),
);
