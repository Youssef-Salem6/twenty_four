import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
// Import the global prefs from main.dart
import 'package:twenty_four/main.dart';

part 'themes_state.dart';

class ThemesCubit extends Cubit<ThemesState> {
  ThemesCubit() : super(const ThemesInitial());

  static const String _themeKey = 'isDarkMode';

  // Load theme from SharedPreferences on app start
  Future<void> loadTheme() async {
    try {
      final isDarkMode =
          prefs.getBool(_themeKey) ?? false; // Default to light mode
      emit(ThemesLoaded(isDarkMode: isDarkMode));
    } catch (e) {
      // If error loading, default to light mode
      emit(const ThemesLoaded(isDarkMode: false));
      print('Error loading theme: $e');
    }
  }

  // Toggle between light and dark mode and save to SharedPreferences
  Future<void> toggleTheme() async {
    try {
      final newDarkMode = !state.isDarkMode;
      await prefs.setBool(_themeKey, newDarkMode);
      emit(ThemesLoaded(isDarkMode: newDarkMode));
    } catch (e) {
      // Handle error - emit current state or show error
      print('Error saving theme: $e');
      // Re-emit current state in case of error
      emit(ThemesLoaded(isDarkMode: state.isDarkMode));
    }
  }

  // Set theme directly and save to SharedPreferences
  Future<void> setTheme(bool isDarkMode) async {
    try {
      await prefs.setBool(_themeKey, isDarkMode);
      emit(ThemesLoaded(isDarkMode: isDarkMode));
    } catch (e) {
      // Handle error
      print('Error saving theme: $e');
      // Re-emit current state in case of error
      emit(ThemesLoaded(isDarkMode: state.isDarkMode));
    }
  }

  // Get current theme status
  bool get isDarkMode => state.isDarkMode;

  // Clear saved theme (optional - for debugging or reset functionality)
  Future<void> clearSavedTheme() async {
    try {
      await prefs.remove(_themeKey);
      emit(const ThemesLoaded(isDarkMode: false)); // Reset to light mode
    } catch (e) {
      print('Error clearing theme: $e');
    }
  }

  // Additional helper methods using global prefs

  // Save any string value
  Future<void> saveString(String key, String value) async {
    try {
      await prefs.setString(key, value);
    } catch (e) {
      print('Error saving string: $e');
    }
  }

  // Get any string value
  String? getString(String key) {
    try {
      return prefs.getString(key);
    } catch (e) {
      print('Error getting string: $e');
      return null;
    }
  }

  // Save any boolean value
  Future<void> saveBool(String key, bool value) async {
    try {
      await prefs.setBool(key, value);
    } catch (e) {
      print('Error saving boolean: $e');
    }
  }

  // Get any boolean value
  bool? getBool(String key) {
    try {
      return prefs.getBool(key);
    } catch (e) {
      print('Error getting boolean: $e');
      return null;
    }
  }
}
