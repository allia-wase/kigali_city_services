import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryLight = Color(0xFF5C3D99);
  static const Color _primaryDark = Color(0xFFB39DDB);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryLight,
        brightness: Brightness.light,
        primary: _primaryLight,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF424242), size: 24),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: Color(0xFF5C3D99),
        labelStyle: TextStyle(color: Color(0xFF424242)),
      ),
      chipTheme: ChipThemeData(
        selectedColor: _primaryLight,
        labelStyle: const TextStyle(color: Colors.white),
        secondaryLabelStyle: const TextStyle(color: Color(0xFF424242)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: _primaryLight,
        unselectedItemColor: Color(0xFF757575),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryDark,
        brightness: Brightness.dark,
        primary: _primaryDark,
      ),
      iconTheme: const IconThemeData(color: Color(0xFFE0E0E0), size: 24),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: _primaryDark,
        labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
      ),
      chipTheme: ChipThemeData(
        selectedColor: _primaryDark,
        labelStyle: const TextStyle(color: Colors.black87),
        secondaryLabelStyle: const TextStyle(color: Color(0xFFE0E0E0)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E2E),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E2E),
        selectedItemColor: _primaryDark,
        unselectedItemColor: Color(0xFF9E9E9E),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}
