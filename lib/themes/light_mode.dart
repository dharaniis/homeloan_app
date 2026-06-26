import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Color(0xFF0F172A),
    secondary: Color(0xFF10B981),
    tertiary: Color(0XFF64748B),
    inversePrimary: Colors.grey.shade900 
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.transparent
  ),
  cardTheme: const CardThemeData(color: Colors.white),
);