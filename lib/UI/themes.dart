import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.yellow,
        surface: Colors.white,
        onSurface: Colors.black,
        outline: Colors.grey));

final darkTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.yellow,
        surface: Colors.black,
        onSurface: Colors.white,
        outline: Colors.grey));
