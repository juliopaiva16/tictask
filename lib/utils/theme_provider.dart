import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'app_settings';
  static const String _themeModeKey = 'theme_mode';
  
  late ThemeMode _themeMode;
  bool _isInitialized = false;

  ThemeProvider() {
    _initThemeMode();
  }

  Future<void> _initThemeMode() async {
    try {
      // Try to open the box or create if it doesn't exist
      if (!Hive.isBoxOpen(_themeBoxName)) {
        await Hive.openBox(_themeBoxName);
      }
      
      final box = Hive.box(_themeBoxName);
      final savedThemeMode = box.get(_themeModeKey);
      
      if (savedThemeMode == null) {
        // If there's no saved theme, use the system theme
        _themeMode = ThemeMode.system;
      } else {
        // Convert the saved value to ThemeMode
        _themeMode = ThemeMode.values[savedThemeMode];
      }
    } catch (e) {
      // In case of error, use system theme
      _themeMode = ThemeMode.system;
      print('Error loading theme mode: $e');
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;

  // Checks if the current theme is dark based on themeMode and system settings
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Uses system brightness to determine
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // Toggles between light and dark themes
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _saveThemeMode();
    notifyListeners();
  }

  // Sets a specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode();
    notifyListeners();
  }

  // Saves the current theme in Hive
  Future<void> _saveThemeMode() async {
    try {
      final box = Hive.box(_themeBoxName);
      await box.put(_themeModeKey, _themeMode.index);
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }
}
