/// Semantic shape foundations (no BorderRadius / Shapes).
/// - Consumes radius tokens.
/// - Exposes semantic radii and stroke widths as raw numbers.
/// - Prepared for ThemeExtension wrapping at theme layer.
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../tokens/radius_tokens.dart';

@immutable
class AppShape {
  /// Corner radii (semantic).
  final double none;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double x2l;
  final double full;

  /// Stroke widths (raw) for borders/dividers/focus rings.
  /// Kept here to avoid scattering raw widths across components.
  final double strokeThin;
  final double strokeThick;

  const AppShape({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.x2l,
    required this.full,
    required this.strokeThin,
    required this.strokeThick,
  });

  factory AppShape.base() {
    return const AppShape(
      none: RadiusTokens.r0,
      sm: RadiusTokens.r8,
      md: RadiusTokens.r12,
      lg: RadiusTokens.r16,
      xl: RadiusTokens.r20,
      x2l: RadiusTokens.r24,
      full: RadiusTokens.rFull,
      strokeThin: 1.0,
      strokeThick: 2.0,
    );
  }

  AppShape copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? x2l,
    double? full,
    double? strokeThin,
    double? strokeThick,
  }) {
    return AppShape(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      x2l: x2l ?? this.x2l,
      full: full ?? this.full,
      strokeThin: strokeThin ?? this.strokeThin,
      strokeThick: strokeThick ?? this.strokeThick,
    );
  }

  AppShape lerp(AppShape other, double t) {
    double l(double a, double b) => lerpDouble(a, b, t) ?? b;

    return AppShape(
      none: l(none, other.none),
      sm: l(sm, other.sm),
      md: l(md, other.md),
      lg: l(lg, other.lg),
      xl: l(xl, other.xl),
      x2l: l(x2l, other.x2l),
      full: l(full, other.full),
      strokeThin: l(strokeThin, other.strokeThin),
      strokeThick: l(strokeThick, other.strokeThick),
    );
  }
}
