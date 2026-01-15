import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that defines the light and dark themes for the application.
///
/// It uses Material 3 design and the Google Fonts`Inter` for a clean,
/// modern, and consistent typography across the app.
class AppTheme {
  /// --------------------------
  /// LIGHT THEME (Material 3)
  /// --------------------------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    dividerColor: const Color.fromARGB(255, 217, 218, 220),
    disabledColor: const Color.fromARGB(255, 227, 227, 227),
    cardColor: const Color.fromARGB(255, 249, 248, 253),
    splashColor: const Color.fromARGB(255, 237, 237, 239),
    shadowColor: const Color.fromARGB(255, 129, 128, 136),
    hintColor: const Color.fromARGB(255, 127, 127, 127),
    highlightColor: const Color.fromARGB(255, 214, 214, 214),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: const Color.fromARGB(255, 127, 127, 127),
      secondary: Colors.grey,
      onTertiary: const Color.fromARGB(255, 239, 239, 247),
      surface: const Color.fromARGB(255, 253, 253, 253),
      // onSurface: const Color.fromARGB(26, 185, 168, 209),
      secondaryContainer: const Color.fromARGB(128, 249, 248, 253),
      onSecondaryContainer: const Color.fromARGB(255, 249, 248, 253),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: const Color.fromARGB(255, 29, 26, 35),
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color.fromARGB(255, 29, 26, 35),
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 29, 26, 35),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 29, 26, 35),
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 29, 26, 35),
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color.fromARGB(255, 29, 26, 35),
      ),
    ),
  );

  /// --------------------------
  /// DARK THEME (Material 3)
  /// --------------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromARGB(255, 29, 26, 35),
    cardColor: const Color.fromARGB(255, 47, 41, 53),
    dividerColor: const Color.fromARGB(255, 42, 42, 42),
    shadowColor: const Color.fromARGB(255, 143, 141, 146),
    hintColor: const Color.fromARGB(255, 210, 210, 212),
    highlightColor: const Color.fromARGB(255, 202, 196, 208),
    splashColor: const Color.fromARGB(255, 58, 58, 60),
    dialogTheme: const DialogThemeData(
      backgroundColor: Color.fromARGB(255, 42, 39, 48),
      barrierColor: Color.fromARGB(255, 132, 224, 125),
      surfaceTintColor: Color.fromARGB(255, 39, 36, 45),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 29, 26, 35),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.dark,
      outline: const Color.fromARGB(255, 210, 210, 212),
      surface: const Color.fromARGB(255, 28, 25, 34),
      primary: Colors.white,
      secondary: Colors.grey,
      onPrimary: Colors.grey,
      onSecondary: const Color.fromARGB(255, 127, 127, 127),
      secondaryContainer: const Color.fromARGB(255, 55, 55, 62),
      onSecondaryContainer: const Color.fromARGB(127, 55, 55, 62),
      onTertiary: const Color.fromARGB(255, 52, 48, 58),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
  );
}