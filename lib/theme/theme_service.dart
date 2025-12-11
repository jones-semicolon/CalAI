import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _key = "themeMode";

  // Save theme as String: "Light", "Dark", "Automatic"
  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, theme);
  }

  // Load theme as String
  Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? "Light"; // default: Light
  }
}
