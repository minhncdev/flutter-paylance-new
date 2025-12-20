/// Motion primitive tokens.
/// - Contains only raw timings and easing curve parameters (no Curve objects).
/// - Theme/foundations can map these to Curves / animations as needed.
library;

import 'package:flutter/material.dart';

@immutable
class MotionDurations {
  static const Duration d50 = Duration(milliseconds: 50);
  static const Duration d100 = Duration(milliseconds: 100);
  static const Duration d150 = Duration(milliseconds: 150);
  static const Duration d200 = Duration(milliseconds: 200);
  static const Duration d250 = Duration(milliseconds: 250);
  static const Duration d300 = Duration(milliseconds: 300);
  static const Duration d400 = Duration(milliseconds: 400);
  static const Duration d500 = Duration(milliseconds: 500);
  static const Duration d700 = Duration(milliseconds: 700);

  /// Common presets.
  static const Duration fast = d150;
  static const Duration medium = d250;
  static const Duration slow = d400;

  const MotionDurations._();
}

/// Cubic-bezier parameters for easing curves.
/// These are raw values to be mapped to platform curves later.
@immutable
class CubicBezierToken {
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  const CubicBezierToken(this.x1, this.y1, this.x2, this.y2);
}

/// A minimal easing set inspired by modern design systems.
/// Names are generic; semantic usage belongs elsewhere.
@immutable
class EasingTokens {
  static const CubicBezierToken linear = CubicBezierToken(0.0, 0.0, 1.0, 1.0);

  /// Balanced easing for most UI transitions.
  static const CubicBezierToken standard = CubicBezierToken(0.2, 0.0, 0.0, 1.0);

  /// Fast-in, slow-out.
  static const CubicBezierToken decelerate = CubicBezierToken(
    0.0,
    0.0,
    0.0,
    1.0,
  );

  /// Slow-in, fast-out.
  static const CubicBezierToken accelerate = CubicBezierToken(
    0.3,
    0.0,
    1.0,
    1.0,
  );

  /// More expressive; use for prominent transitions (dialogs/sheets).
  static const CubicBezierToken emphasized = CubicBezierToken(
    0.2,
    0.0,
    0.0,
    1.2,
  );

  const EasingTokens._();
}
