import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --------------------------
  // LIGHT THEME (Material 3)
  // --------------------------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Main background for screens
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),

    // Cards, containers, item backgrounds
    cardColor: const Color.fromARGB(255, 255, 255, 255),

    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    // Material 3 color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
      outline: Color.fromARGB(255, 210, 210, 212),
      surface: const Color.fromARGB(255, 255, 255, 255), // cards
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      onPrimary: const Color.fromARGB(255, 29, 26, 35),
      onSecondary: Colors.white,
      onSurface: Colors.black,
    ),

    // Google Fonts text theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.black45,
      ),
    ),
  );

  // --------------------------
  // DARK THEME (Material 3)
  // --------------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color.fromARGB(255, 29, 26, 35),
    cardColor: const Color.fromARGB(255, 40, 35, 50),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 29, 26, 35),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      outline: Color.fromARGB(255, 75, 72, 79),
      brightness: Brightness.dark,
      surface: const Color.fromARGB(255, 40, 35, 50),
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),

    // Google Fonts text theme (adjust colors for dark mode)
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white60,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.white54,
      ),
    ),
  );
}
