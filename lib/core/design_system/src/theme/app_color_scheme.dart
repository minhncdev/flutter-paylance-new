/// Maps DS semantic colors (AppColors) into Flutter ColorScheme (Material 3).
/// - Theme layer only (no widgets).
library;

import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';

@immutable
class AppColorScheme {
  const AppColorScheme._();

  static ColorScheme fromAppColors({
    required AppColors colors,
    required Brightness brightness,
  }) {
    // Keep mapping stable; semantic roles come from AppColors.
    return ColorScheme(
      brightness: brightness,

      // Brand
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primaryContainer,
      onPrimaryContainer: colors.onPrimaryContainer,

      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      secondaryContainer: colors.secondaryContainer,
      onSecondaryContainer: colors.onSecondaryContainer,

      tertiary: colors.accent,
      onTertiary: colors.onAccent,
      tertiaryContainer: colors.secondaryContainer,
      onTertiaryContainer: colors.onSecondaryContainer,

      // Status
      error: colors.danger,
      onError: colors.onDanger,
      errorContainer: colors.dangerContainer,
      onErrorContainer: colors.onDangerContainer,

      // Surfaces
      surface: colors.surface,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.surfaceElevated,
      onSurfaceVariant: colors.textSecondary,

      // Background
      background: colors.background,
      onBackground: colors.textPrimary,

      // Outlines
      outline: colors.border,
      outlineVariant: colors.divider,

      // Inverse
      inverseSurface: colors.textPrimary,
      onInverseSurface: colors.background,
      inversePrimary: colors.primary,

      // M3 surface tint used by elevation overlays.
      surfaceTint: colors.primary,

      // Scrim
      scrim: colors.scrim,
    );
  }
}
