import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for managing theme-related preferences.
///
/// This class provides methods to save and load the user's selected theme mode
/// using the `shared_preferences` package for persistence.
class ThemeService {
  // A private constant key for storing the theme mode in shared preferences.
  static const String _key = "themeMode";

  /// Saves the selected theme mode as a string: "Light", "Dark", or "Automatic".
  ///
  /// The [theme] parameter should be one of these three string values.
  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, theme);
  }

  /// Loads the saved theme mode as a string from shared preferences.
  ///
  /// If no theme mode is found, it defaults to "Light".
  /// Returns a [Future] that completes with the theme mode string.
  Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? "Automatic";
  }
}