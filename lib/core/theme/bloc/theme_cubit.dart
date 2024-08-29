import 'package:chatapp/theme/dark_theme.dart';
import 'package:chatapp/theme/light_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<bool> {
  // Initial state is light mode
  ThemeCubit() : super(false); // Initial state is light mode (false)

  static final ThemeData light = lightMode;
  static final ThemeData dark = darkMode;

  ThemeData get currentTheme => state ? dark : light;

  void toggleTheme() => emit(!state); // Toggle between light and dark mode
}
