/// Maps DS typography (AppTypography/TextSpec) into Flutter TextTheme (Material 3).
/// - Theme layer only (no widgets).
library;

import 'package:flutter/material.dart';

import '../foundations/app_typography.dart';

@immutable
class AppTextTheme {
  const AppTextTheme._();

  static TextTheme fromTypography(AppTypography typography) {
    return TextTheme(
      displayLarge: _toTextStyle(typography.displayLarge),
      displayMedium: _toTextStyle(typography.displayMedium),
      displaySmall: _toTextStyle(typography.displaySmall),

      headlineLarge: _toTextStyle(typography.headlineLarge),
      headlineMedium: _toTextStyle(typography.headlineMedium),
      headlineSmall: _toTextStyle(typography.headlineSmall),

      titleLarge: _toTextStyle(typography.titleLarge),
      titleMedium: _toTextStyle(typography.titleMedium),
      titleSmall: _toTextStyle(typography.titleSmall),

      bodyLarge: _toTextStyle(typography.bodyLarge),
      bodyMedium: _toTextStyle(typography.bodyMedium),
      bodySmall: _toTextStyle(typography.bodySmall),

      labelLarge: _toTextStyle(typography.labelLarge),
      labelMedium: _toTextStyle(typography.labelMedium),
      labelSmall: _toTextStyle(typography.labelSmall),
    );
  }

  static TextStyle _toTextStyle(TextSpec spec) {
    // Convert absolute lineHeightPx into Flutter height multiplier.
    final height = spec.fontSize == 0
        ? null
        : (spec.lineHeightPx / spec.fontSize);

    return TextStyle(
      fontFamily: spec.fontFamilyFallback.isNotEmpty
          ? spec.fontFamilyFallback.first
          : null,
      fontFamilyFallback: spec.fontFamilyFallback.length > 1
          ? spec.fontFamilyFallback.sublist(1)
          : null,
      fontWeight: _mapWeight(spec.fontWeight),
      fontSize: spec.fontSize,
      height: height,
      letterSpacing: spec.letterSpacing,
    );
  }

  static FontWeight _mapWeight(int w) {
    // Map numeric weights to Flutter FontWeight.
    if (w <= 100) return FontWeight.w100;
    if (w <= 200) return FontWeight.w200;
    if (w <= 300) return FontWeight.w300;
    if (w <= 400) return FontWeight.w400;
    if (w <= 500) return FontWeight.w500;
    if (w <= 600) return FontWeight.w600;
    if (w <= 700) return FontWeight.w700;
    if (w <= 800) return FontWeight.w800;
    return FontWeight.w900;
  }
}
