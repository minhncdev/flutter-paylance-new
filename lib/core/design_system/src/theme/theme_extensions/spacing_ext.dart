/// ThemeExtension wrapper for semantic spacing (AppSpacing).
/// - Provides centralized spacing + optional inset helpers.
/// - Keeps EdgeInsets creation out of components ("no scattered EdgeInsets").
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';

@immutable
class DsSpacingExt extends ThemeExtension<DsSpacingExt> {
  final AppSpacing spacing;

  const DsSpacingExt({required this.spacing});

  @override
  DsSpacingExt copyWith({AppSpacing? spacing}) {
    return DsSpacingExt(spacing: spacing ?? this.spacing);
  }

  @override
  DsSpacingExt lerp(ThemeExtension<DsSpacingExt>? other, double t) {
    if (other is! DsSpacingExt) return this;
    return DsSpacingExt(spacing: spacing.lerp(other.spacing, t));
  }

  // ---------- Centralized EdgeInsets helpers (optional but recommended) ----------
  EdgeInsets all(double v) => EdgeInsets.all(v);

  EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }

  EdgeInsets horizontal(double v) => EdgeInsets.symmetric(horizontal: v);

  EdgeInsets vertical(double v) => EdgeInsets.symmetric(vertical: v);

  EdgeInsets lerpInsets(EdgeInsets a, EdgeInsets b, double t) {
    return EdgeInsets.lerp(a, b, t) ??
        EdgeInsets.only(
          left: lerpDouble(a.left, b.left, t) ?? b.left,
          top: lerpDouble(a.top, b.top, t) ?? b.top,
          right: lerpDouble(a.right, b.right, t) ?? b.right,
          bottom: lerpDouble(a.bottom, b.bottom, t) ?? b.bottom,
        );
  }
}
