import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF56719B), // State Blue
    secondary: Color(0xFFBDCFE7), // Cloudy Blue
    surface: Color(0xFFF8E8F5), // Amour for surfaces
    background: Color(0xFFB4D1B3), // Gum Leaf
    error: Colors.red, // Default red for error
    onPrimary: Colors.white, // Text/icon color on primary
    onSecondary: Colors.black, // Text/icon color on secondary
    onSurface: Colors.black, // Text/icon color on surface
    onBackground: Colors.black, // Text/icon color on background
    onError: Colors.white, // Text/icon color on error
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF56719B), // State Blue
    secondary: Color(0xFFA7C9D3), // Opal
    surface: Color(0xFF69858C), // Steel for surfaces
    background: Color(0xFF56719B), // State Blue for backgrounds
    error: Colors.redAccent, // Slightly lighter red for error
    onPrimary: Colors.black, // Text/icon color on primary
    onSecondary: Colors.white, // Text/icon color on secondary
    onSurface: Colors.white, // Text/icon color on surface
    onBackground: Colors.white, // Text/icon color on background
    onError: Colors.black, // Text/icon color on error
  ),
);
