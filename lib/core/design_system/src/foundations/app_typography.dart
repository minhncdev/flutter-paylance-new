/// Semantic typography foundations (no TextStyle).
/// - Consumes only typography tokens (sizes/weights/line-heights/letter-spacing/families).
/// - Exposes stable semantic roles to be mapped into TextTheme at theme layer.
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../tokens/typography_tokens.dart';

@immutable
class TextSpec {
  /// Primary font family stack for this role.
  final List<String> fontFamilyFallback;

  /// Numeric weight (100..900) from tokens.
  final int fontWeight;

  /// Font size in logical pixels.
  final double fontSize;

  /// Absolute line height in logical pixels (converted to height ratio in theme).
  final double lineHeightPx;

  /// Letter spacing in logical pixels.
  final double letterSpacing;

  const TextSpec({
    required this.fontFamilyFallback,
    required this.fontWeight,
    required this.fontSize,
    required this.lineHeightPx,
    required this.letterSpacing,
  });

  TextSpec copyWith({
    List<String>? fontFamilyFallback,
    int? fontWeight,
    double? fontSize,
    double? lineHeightPx,
    double? letterSpacing,
  }) {
    return TextSpec(
      fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      lineHeightPx: lineHeightPx ?? this.lineHeightPx,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    );
  }

  TextSpec lerp(TextSpec other, double t) {
    int lerpWeight(int a, int b) => (a + ((b - a) * t)).round();

    return TextSpec(
      fontFamilyFallback: t < 0.5
          ? fontFamilyFallback
          : other.fontFamilyFallback,
      fontWeight: lerpWeight(fontWeight, other.fontWeight),
      fontSize: lerpDouble(fontSize, other.fontSize, t) ?? other.fontSize,
      lineHeightPx:
          lerpDouble(lineHeightPx, other.lineHeightPx, t) ?? other.lineHeightPx,
      letterSpacing:
          lerpDouble(letterSpacing, other.letterSpacing, t) ??
          other.letterSpacing,
    );
  }
}

/// Semantic typography contract, aligned with Material type roles naming.
/// Theme layer maps these specs into `TextTheme`.
@immutable
class AppTypography {
  final TextSpec displayLarge;
  final TextSpec displayMedium;
  final TextSpec displaySmall;

  final TextSpec headlineLarge;
  final TextSpec headlineMedium;
  final TextSpec headlineSmall;

  final TextSpec titleLarge;
  final TextSpec titleMedium;
  final TextSpec titleSmall;

  final TextSpec bodyLarge;
  final TextSpec bodyMedium;
  final TextSpec bodySmall;

  final TextSpec labelLarge;
  final TextSpec labelMedium;
  final TextSpec labelSmall;

  const AppTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// Default semantic mapping from primitive typography tokens.
  /// Brands can override by providing another AppTypography instance at theme layer.
  factory AppTypography.base() {
    final sans = FontFamilyTokens.sansStack;

    return AppTypography(
      displayLarge: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w700,
        fontSize: FontSizeTokens.f48,
        lineHeightPx: LineHeightTokens.lh64,
        letterSpacing: LetterSpacingTokens.n05,
      ),
      displayMedium: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w700,
        fontSize: FontSizeTokens.f40,
        lineHeightPx: LineHeightTokens.lh56,
        letterSpacing: LetterSpacingTokens.n02,
      ),
      displaySmall: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f36,
        lineHeightPx: LineHeightTokens.lh48,
        letterSpacing: LetterSpacingTokens.n02,
      ),
      headlineLarge: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f32,
        lineHeightPx: LineHeightTokens.lh40,
        letterSpacing: LetterSpacingTokens.n02,
      ),
      headlineMedium: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f28,
        lineHeightPx: LineHeightTokens.lh36,
        letterSpacing: LetterSpacingTokens.n02,
      ),
      headlineSmall: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f24,
        lineHeightPx: LineHeightTokens.lh32,
        letterSpacing: LetterSpacingTokens.n02,
      ),
      titleLarge: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f20,
        lineHeightPx: LineHeightTokens.lh28,
        letterSpacing: LetterSpacingTokens.z0,
      ),
      titleMedium: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f16,
        lineHeightPx: LineHeightTokens.lh24,
        letterSpacing: LetterSpacingTokens.p02,
      ),
      titleSmall: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f14,
        lineHeightPx: LineHeightTokens.lh20,
        letterSpacing: LetterSpacingTokens.p02,
      ),
      bodyLarge: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w400,
        fontSize: FontSizeTokens.f16,
        lineHeightPx: LineHeightTokens.lh24,
        letterSpacing: LetterSpacingTokens.p02,
      ),
      bodyMedium: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w400,
        fontSize: FontSizeTokens.f14,
        lineHeightPx: LineHeightTokens.lh20,
        letterSpacing: LetterSpacingTokens.p02,
      ),
      bodySmall: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w400,
        fontSize: FontSizeTokens.f12,
        lineHeightPx: LineHeightTokens.lh16,
        letterSpacing: LetterSpacingTokens.p04,
      ),
      labelLarge: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f14,
        lineHeightPx: LineHeightTokens.lh20,
        letterSpacing: LetterSpacingTokens.p04,
      ),
      labelMedium: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f12,
        lineHeightPx: LineHeightTokens.lh16,
        letterSpacing: LetterSpacingTokens.p04,
      ),
      labelSmall: TextSpec(
        fontFamilyFallback: sans,
        fontWeight: FontWeightTokens.w600,
        fontSize: FontSizeTokens.f10,
        lineHeightPx: LineHeightTokens.lh12,
        letterSpacing: LetterSpacingTokens.p08,
      ),
    );
  }

  AppTypography copyWith({
    TextSpec? displayLarge,
    TextSpec? displayMedium,
    TextSpec? displaySmall,
    TextSpec? headlineLarge,
    TextSpec? headlineMedium,
    TextSpec? headlineSmall,
    TextSpec? titleLarge,
    TextSpec? titleMedium,
    TextSpec? titleSmall,
    TextSpec? bodyLarge,
    TextSpec? bodyMedium,
    TextSpec? bodySmall,
    TextSpec? labelLarge,
    TextSpec? labelMedium,
    TextSpec? labelSmall,
  }) {
    return AppTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  AppTypography lerp(AppTypography other, double t) {
    return AppTypography(
      displayLarge: displayLarge.lerp(other.displayLarge, t),
      displayMedium: displayMedium.lerp(other.displayMedium, t),
      displaySmall: displaySmall.lerp(other.displaySmall, t),
      headlineLarge: headlineLarge.lerp(other.headlineLarge, t),
      headlineMedium: headlineMedium.lerp(other.headlineMedium, t),
      headlineSmall: headlineSmall.lerp(other.headlineSmall, t),
      titleLarge: titleLarge.lerp(other.titleLarge, t),
      titleMedium: titleMedium.lerp(other.titleMedium, t),
      titleSmall: titleSmall.lerp(other.titleSmall, t),
      bodyLarge: bodyLarge.lerp(other.bodyLarge, t),
      bodyMedium: bodyMedium.lerp(other.bodyMedium, t),
      bodySmall: bodySmall.lerp(other.bodySmall, t),
      labelLarge: labelLarge.lerp(other.labelLarge, t),
      labelMedium: labelMedium.lerp(other.labelMedium, t),
      labelSmall: labelSmall.lerp(other.labelSmall, t),
    );
  }
}
