/// ThemeExtension wrapper for semantic shape (AppShape).
/// - Centralizes radii + stroke widths.
/// - Provides BorderRadius helpers so components avoid scattered BorderRadius creation.
library;

import 'package:flutter/material.dart';

import '../../foundations/app_shape.dart';

@immutable
class DsRadiiExt extends ThemeExtension<DsRadiiExt> {
  final AppShape shape;

  const DsRadiiExt({required this.shape});

  @override
  DsRadiiExt copyWith({AppShape? shape}) {
    return DsRadiiExt(shape: shape ?? this.shape);
  }

  @override
  DsRadiiExt lerp(ThemeExtension<DsRadiiExt>? other, double t) {
    if (other is! DsRadiiExt) return this;
    return DsRadiiExt(shape: shape.lerp(other.shape, t));
  }

  // Centralized BorderRadius helpers:
  BorderRadius circular(double r) => BorderRadius.circular(r);

  BorderRadius get sm => BorderRadius.circular(shape.sm);
  BorderRadius get md => BorderRadius.circular(shape.md);
  BorderRadius get lg => BorderRadius.circular(shape.lg);
  BorderRadius get xl => BorderRadius.circular(shape.xl);
}
