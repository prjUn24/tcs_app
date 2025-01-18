import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Colors.grey,
    primary: Colors.blue,
    secondary: Colors.purple,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.red,
    secondary: Colors.purple,
  ),
);
