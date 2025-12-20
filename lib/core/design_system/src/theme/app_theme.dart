/// Public theme entry points for the Design System.
/// - Provides ready-to-use ThemeData (M3 light/dark) via AppThemeBuilder.
/// - No widgets; suitable for app/ bootstrap layer.
library;

import 'package:flutter/material.dart';

import 'theme_builder.dart';

@immutable
class AppTheme {
  const AppTheme._();

  static ThemeBundle build({AppThemeConfig? config}) {
    return AppThemeBuilder.build(config: config);
  }

  static ThemeData light({AppThemeConfig? config}) {
    return AppThemeBuilder.build(config: config).light;
  }

  static ThemeData dark({AppThemeConfig? config}) {
    return AppThemeBuilder.build(config: config).dark;
  }
}
