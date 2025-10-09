import 'package:flutter/material.dart';

class AppThemes {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    fontFamily: "Almarai",
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFFE2E2E2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFE2E2E2),
      foregroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[100],
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    dividerColor: Colors.grey[300],
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey.withOpacity(0.2),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    fontFamily: "Almarai",
    brightness: Brightness.dark,
    primaryColor: Colors.blue[700],
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFF424242),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF424242),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[800],
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    dividerColor: Colors.grey[700],
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[800],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  // Get appropriate theme based on isDarkMode boolean
  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }

  // Helper methods
  static Color getIconColor(bool isDarkMode) {
    return isDarkMode ? Color(0xFFE2E2E2) : Colors.black87;
  }

  static Color getTextColor(bool isDarkMode) {
    return isDarkMode ? Color(0xFFE2E2E2) : Colors.black;
  }

  static Color getCardColor(bool isDarkMode) {
    return isDarkMode ? Colors.grey[850]! : Color.fromARGB(255, 255, 255, 255);
  }

  static Color getScaffoldColor(bool isDarkMode) {
    return isDarkMode ? Color(0xff141c27) : Color(0xFFE2E2E2);
  }

  static Color getSearchBarColor(bool isDarkMode) {
    return isDarkMode ? Colors.grey[800]! : Color(0xFFE2E2E2);
  }

  static Color getHintColor(bool isDarkMode) {
    return isDarkMode ? Color(0xFFE2E2E2) : Colors.black54;
  }

  static Color getUnselectedTabColor(bool isDarkMode) {
    return isDarkMode ? Colors.white60 : Colors.grey[600]!;
  }
}
