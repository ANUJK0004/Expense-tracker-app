import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: Colors.brown.shade100,

    primaryColor: Colors.brown.shade50,

    shadowColor: Colors.brown.shade700,

    colorScheme: ColorScheme.light(
      primary: Colors.brown,
      secondary: Colors.orange,

    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      elevation: 4,
      color: Colors.brown.shade100,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    floatingActionButtonTheme:
    FloatingActionButtonThemeData(
      backgroundColor: Colors.brown,
    ),
  );



  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: Color(0xff121212),

    primaryColor: Color(0xff1E1E1E),

    shadowColor: Colors.black,

    colorScheme: ColorScheme.dark(
      primary: Colors.orange,
      secondary: Colors.orangeAccent,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xff1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      elevation: 4,
      color: Color(0xff1E1E1E),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize:16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    floatingActionButtonTheme:
    FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
    ),
  );
}