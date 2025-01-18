import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF56719B), // State Blue
    secondary: Color(0xFFBDCFE7), // Cloudy Blue
    surface: Color(0xFFF8E8F5), // Amour for surfaces
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF56719B), // State Blue for consistency
    secondary: Color(0xFFA7C9D3), // Opal
    surface: Color(0xFF69858C), // Steel for surfaces
    onPrimary: Colors.black,
    onSecondary: Colors.white,
  ),
);
