import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme defines the Light and Dark themes for the app using Material 3.
/// Uses GoogleFonts.inter() for a consistent, modern sans-serif typography.
class AppTheme {
  // --------------------------
  // LIGHT THEME (Material 3)
  // --------------------------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Scaffold background
    // scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    //
    // // Card, container, and item backgrounds
    cardColor: const Color.fromARGB(255, 249, 248, 253),
    splashColor: const Color.fromARGB(255, 237, 237, 239),
    //
    // // Dividers and shadows
    // dividerColor: const Color.fromARGB(255, 217, 218, 220),
    shadowColor: const Color.fromARGB(255, 129, 128, 136),
    //
    // // Hints and highlights
    hintColor: const Color.fromARGB(255, 127, 127, 127),
    highlightColor: const Color.fromARGB(255, 214, 214, 214),
    // splashColor: const Color.fromARGB(255, 217, 218, 220),

    // AppBar styling
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    // Material 3 Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Color.fromARGB(255, 127, 127, 127),
      secondary: Colors.grey,
      onTertiary: Color.fromARGB(255, 239, 239, 247),
      // outline: const Color.fromARGB(255, 75, 72, 79),
      surface: const Color.fromARGB(255, 250, 249, 254),
      // primary: Colors.black,
      // secondary: const Color.fromARGB(255, 248, 247, 252),
      // onPrimary: Colors.white,
      // onSecondary: const Color.fromARGB(255, 28, 25, 34),
      secondaryContainer: const Color.fromARGB(128, 249, 248, 253),
      onSecondaryContainer: const Color.fromARGB(255, 249, 248, 253),
    ),

    // Dialog styling
    // dialogTheme: const DialogThemeData(
    //   backgroundColor: Color.fromARGB(255, 217, 218, 220),
    //   barrierColor: Color.fromARGB(255, 29, 26, 35),
    //   surfaceTintColor: Color.fromARGB(255, 249, 248, 253),
    // ),

    // Global Text Theme using Inter font
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

  // --------------------------
  // DARK THEME (Material 3)
  // --------------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Scaffold background
    scaffoldBackgroundColor: const Color.fromARGB(255, 29, 26, 35),

    // Cards
    cardColor: const Color.fromARGB(255, 47, 41, 53),

    // Dividers and shadows
    dividerColor: const Color.fromARGB(255, 42, 42, 42),
    shadowColor: const Color.fromARGB(255, 143, 141, 146),

    // Hints and highlights
    hintColor: const Color.fromARGB(255, 210, 210, 212),
    highlightColor: const Color.fromARGB(255, 202, 196, 208),
    splashColor: const Color.fromARGB(255, 58, 58, 60),

    // Dialog styling
    dialogTheme: const DialogThemeData(
      backgroundColor: Color.fromARGB(255, 42, 39, 48),
      barrierColor: Color.fromARGB(255, 132, 224, 125),
      surfaceTintColor: Color.fromARGB(255, 39, 36, 45),
    ),

    // AppBar styling
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 29, 26, 35),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    // Material 3 Color Scheme
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
      onTertiary: Color.fromARGB(255, 52, 48, 58),
    ),

    // Global Text Theme using Inter font
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
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
        fontSize: 12,
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
