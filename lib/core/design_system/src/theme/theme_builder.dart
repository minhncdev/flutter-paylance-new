/// Theme builder (composition) for DS themes.
/// - Token-driven: builds foundations from tokens, then maps to ThemeData + ThemeExtensions.
/// - No app_state / no features.
/// - Supports multi-brand via palettes + BrandColorSelection.
library;

import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';
import '../foundations/app_elevation.dart';
import '../foundations/app_shape.dart';
import '../foundations/app_spacing.dart';
import '../foundations/app_typography.dart';
import '../tokens/color_palette.dart';
import 'app_color_scheme.dart';
import 'app_text_theme.dart';
import 'theme_extensions/component_styles_ext.dart';
import 'theme_extensions/elevation_ext.dart';
import 'theme_extensions/radii_ext.dart';
import 'theme_extensions/spacing_ext.dart';

@immutable
class AppThemeConfig {
  final PrimitivePalettes palettes;
  final BrandColorSelection brand;
  final AppTypography typography;
  final AppSpacing spacing;
  final AppShape shape;
  final AppElevation elevation;

  const AppThemeConfig({
    required this.palettes,
    required this.brand,
    required this.typography,
    required this.spacing,
    required this.shape,
    required this.elevation,
  });

  factory AppThemeConfig.base() {
    return AppThemeConfig(
      palettes: PrimitivePalettes.base,
      brand: BrandColorSelection.base,
      typography: AppTypography.base(),
      spacing: AppSpacing.base(),
      shape: AppShape.base(),
      elevation: AppElevation.base(),
    );
  }
}

@immutable
class ThemeBundle {
  final ThemeData light;
  final ThemeData dark;

  const ThemeBundle({required this.light, required this.dark});
}

@immutable
class AppThemeBuilder {
  const AppThemeBuilder._();

  static ThemeBundle build({AppThemeConfig? config}) {
    final cfg = config ?? AppThemeConfig.base();

    final light = _buildFor(
      brightness: Brightness.light,
      colors: AppColors.light(palettes: cfg.palettes, brand: cfg.brand),
      typography: cfg.typography,
      spacing: cfg.spacing,
      shape: cfg.shape,
      elevation: cfg.elevation,
    );

    final dark = _buildFor(
      brightness: Brightness.dark,
      colors: AppColors.dark(palettes: cfg.palettes, brand: cfg.brand),
      typography: cfg.typography,
      spacing: cfg.spacing,
      shape: cfg.shape,
      elevation: cfg.elevation,
    );

    return ThemeBundle(light: light, dark: dark);
  }

  static ThemeData _buildFor({
    required Brightness brightness,
    required AppColors colors,
    required AppTypography typography,
    required AppSpacing spacing,
    required AppShape shape,
    required AppElevation elevation,
  }) {
    final scheme = AppColorScheme.fromAppColors(
      colors: colors,
      brightness: brightness,
    );
    final textTheme = AppTextTheme.fromTypography(typography);

    final dsSpacing = DsSpacingExt(spacing: spacing);
    final dsRadii = DsRadiiExt(shape: shape);
    final dsElevation = DsElevationExt(elevation: elevation);
    final dsComponentStyles = DsComponentStylesExt.base(
      shape: shape,
      spacing: spacing,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,

      // Keep DS extensions registered for consumption by components/layouts.
      extensions: <ThemeExtension<dynamic>>[
        dsSpacing,
        dsRadii,
        dsElevation,
        dsComponentStyles,
      ],

      // Provide sensible defaults without hardcoding colors/typography
      // beyond scheme/textTheme mapping (token-driven).
      scaffoldBackgroundColor: scheme.background,

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: shape.strokeThin,
        space: 0,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        actionTextColor: scheme.inversePrimary,
      ),

      // NOTE: InputDecorationTheme details can be mapped later (still no UI widgets here).
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        // Colors are from ColorScheme (token-driven via AppColors).
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: scheme.outline,
            width: shape.strokeThin,
          ),
          borderRadius: BorderRadius.circular(shape.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.focusRing,
            width: shape.strokeThick,
          ),
          borderRadius: BorderRadius.circular(shape.md),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.error, width: shape.strokeThin),
          borderRadius: BorderRadius.circular(shape.md),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.error, width: shape.strokeThick),
          borderRadius: BorderRadius.circular(shape.md),
        ),
      ),
    );
  }
}
