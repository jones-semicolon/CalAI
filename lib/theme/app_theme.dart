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
    cardColor: const Color.fromARGB(255, 237, 237, 239),

    dividerColor: Color.fromARGB(255, 239, 240, 245),

    shadowColor: Color.fromARGB(255, 142, 140, 145),

    hintColor: Color.fromARGB(255, 127, 126, 132),
    highlightColor: Color.fromARGB(255, 72, 69, 78),

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
      primary: Colors.white, // black and white
      secondary: Color.fromARGB(255, 249, 248, 253),
      onPrimary: Color.fromARGB(255, 29, 26, 35),
      onSecondary: Color.fromARGB(255, 127, 127, 127),
      onSurface: Color.fromARGB(255, 243, 244, 246),
    ),

    // Google Fonts text theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Color.fromARGB(255, 29, 26, 35),
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 29, 26, 35),
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 29, 26, 35),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 29, 26, 35),
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 29, 26, 35),
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color.fromARGB(255, 29, 26, 35),
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
    cardColor: const Color.fromARGB(
      255,
      47,
      41,
      53,
    ), // used in circular progress indicator bg color

    dividerColor: Color.fromARGB(255, 42, 42, 42), //used in card border

    shadowColor: Color.fromARGB(255, 143, 141, 146), // use in day time circle
    hintColor: Color.fromARGB(255, 151, 148, 155), // use day time not active
    highlightColor: Color.fromARGB(255, 202, 196, 208), // used in setting name

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(
        255,
        29,
        26,
        35,
      ), // used in card, bg color
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      outline: Color.fromARGB(255, 75, 72, 79), // used in bullet indicator
      brightness: Brightness.dark,
      surface: const Color.fromARGB(255, 40, 35, 50),
      primary: Colors.black,
      secondary: Color.fromARGB(255, 39, 36, 45), // used in icon bg floating
      onPrimary: Colors.white, // used in reverse of scaffold color
      onSecondary: Color.fromARGB(
        255,
        176,
        176,
        176,
      ), // used in navbar if not active
      onSurface: Color.fromARGB(255, 43, 39, 53), //used in calorie border
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
