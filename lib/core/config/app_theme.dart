import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme(
      color: AppColors.appBarColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.buttonColor,
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: AppColors.textColor,
        fontFamily: 'Nexa',
      ),
      bodyMedium: TextStyle(
        color: AppColors.textColor,
        fontFamily: 'Nexa',
      ),
      bodyLarge: TextStyle(
        color: AppColors.textColor,
        fontFamily: 'Nexa',
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppColors.inputFillColor,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightGrey),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.white,
      secondary: AppColors.accentColor,
      onSecondary: AppColors.white,
      background: AppColors.backgroundColor,
      onBackground: AppColors.textColor,
      surface: AppColors.backgroundColor,
      onSurface: AppColors.textColor,
      error: AppColors.redColor,
      onError: AppColors.white,
    )
        .copyWith(secondary: AppColors.accentColor)
        .copyWith(background: AppColors.backgroundColor),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.black,
    appBarTheme: const AppBarTheme(
      color: AppColors.blackLight,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.buttonColor,
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: AppColors.white,
        fontFamily: 'Nexa',
      ),
      bodyMedium: TextStyle(
        color: AppColors.white,
        fontFamily: 'Nexa',
      ),
      bodyLarge: TextStyle(
        color: AppColors.white,
        fontFamily: 'Nexa',
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppColors.inputFillColor,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkGrey),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.white,
      secondary: AppColors.accentColor,
      onSecondary: AppColors.white,
      background: AppColors.black,
      onBackground: AppColors.white,
      surface: AppColors.black,
      onSurface: AppColors.white,
      error: AppColors.redColor,
      onError: AppColors.white,
    )
        .copyWith(secondary: AppColors.accentColor)
        .copyWith(background: AppColors.black),
  );
}
