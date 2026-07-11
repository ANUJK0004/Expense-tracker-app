import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.brown,
      brightness: Brightness.light
    ),
    scaffoldBackgroundColor: Colors.brown.shade100,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.brown.shade200,
      foregroundColor: Colors.brown.shade900,
    )
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.brown,
      brightness: Brightness.dark
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      // backgroundColor: Colors.brown.shade900,
      // foregroundColor: Colors.brown.shade100,
    )
  );
}