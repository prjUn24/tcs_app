import 'package:flutter/material.dart';
import 'package:tcs/theme/theme.dart'; // Assuming lightMode and darkMode are defined here.

class ThemeProvider with ChangeNotifier {
  // Default theme is lightMode
  ThemeData _themeData = lightMode;

  // Getter to access the current theme
  ThemeData get themeData => _themeData;

  // Toggle between light and dark mode
  void toggleTheme() {
    // Switch between light and dark mode
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }

    // Notify listeners to update the UI
    notifyListeners();
  }
}
