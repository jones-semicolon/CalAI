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
    splashColor: Color.fromARGB(255, 217, 218, 220),
    primaryColor: Color.fromARGB(255, 111, 111, 111),
    primaryColorLight: Color.fromARGB(255, 249, 248, 253), // timeline
    primaryColorDark: Color.fromARGB(255, 195, 195, 195),
    unselectedWidgetColor: Color.fromARGB(255, 251, 251, 251),
    canvasColor: Colors.white,
    focusColor: Colors.black,
    secondaryHeaderColor: Color.fromARGB(255, 127, 127, 127),

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
      onPrimaryFixed: Color.fromARGB(255, 255, 255, 255),
      onSecondary: Color.fromARGB(255, 127, 127, 127),
      onTertiary: Color.fromARGB(255, 74, 71, 80), // timeline progress
      onSurface: Color.fromARGB(255, 243, 244, 246),
      onSurfaceVariant: Color.fromARGB(255, 228, 228, 228),
      inversePrimary: Color.fromARGB(255, 188, 188, 190),
      onTertiaryFixed: Color.fromARGB(255, 122, 117, 124),
      scrim: Color.fromARGB(255, 239, 246, 238),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: Color.fromARGB(255, 217, 218, 220),
      barrierColor: Color.fromARGB(255, 29, 26, 35),
      surfaceTintColor: Color.fromARGB(255, 249, 248, 253),
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
      titleMedium: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
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
    splashColor: Color.fromARGB(255, 58, 58, 60), // use in div
    primaryColor: Color.fromARGB(255, 142, 140, 145), // used in text grey
    primaryColorLight: Color.fromARGB(255, 55, 55, 63), // timeline
    primaryColorDark: Color.fromARGB(255, 77, 74, 81),
    unselectedWidgetColor: Color.fromARGB(255, 33, 30, 39),
    canvasColor: Colors.black,
    focusColor: Colors.white,
    secondaryHeaderColor: Color.fromARGB(255, 176, 176, 176),

    dialogTheme: DialogThemeData(
      backgroundColor: Color.fromARGB(255, 42, 39, 48),
      barrierColor: Color.fromARGB(255, 132, 224, 125),
      surfaceTintColor: Color.fromARGB(255, 39, 36, 45),
    ),

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
      onPrimaryFixed: Color.fromARGB(255, 137, 137, 139), // timeline progress
      onTertiary: Color.fromARGB(255, 215, 215, 217), // timeline progress
      onSecondary: Color.fromARGB(
        255,
        176,
        176,
        176,
      ), // used in navbar if not active
      onSurfaceVariant: Color.fromARGB(255, 56, 53, 62),
      inversePrimary: Color.fromARGB(255, 97, 94, 101),
      onSurface: Color.fromARGB(255, 43, 39, 53), //used in calorie border
      scrim: Color.fromARGB(255, 32, 35, 36),
      onTertiaryFixed: Color.fromARGB(255, 146, 143, 152),
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
