// app/theme/theme_state.dart
//
// Immutable theme state for MaterialApp wiring.

library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme_selection_config.dart';

@immutable
class ThemeState {
  final ThemeSelectionConfig config;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  const ThemeState({
    required this.config,
    required this.lightTheme,
    required this.darkTheme,
    required this.themeMode,
  });
}
