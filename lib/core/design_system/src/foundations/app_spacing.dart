/// Semantic spacing foundations (no EdgeInsets).
/// - Consumes only spacing tokens.
/// - Exposes a stable spacing API for UI.
/// - Prepared for ThemeExtension wrapping at theme layer.
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../tokens/spacing_tokens.dart';

@immutable
class AppSpacing {
  /// Base spacing scale (semantic aliases).
  final double none;
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double x2l;
  final double x3l;
  final double x4l;

  /// Layout-friendly aliases.
  final double gutter;
  final double pagePadding;
  final double sectionGap;
  final double itemGap;

  const AppSpacing({
    required this.none,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.x2l,
    required this.x3l,
    required this.x4l,
    required this.gutter,
    required this.pagePadding,
    required this.sectionGap,
    required this.itemGap,
  });

  factory AppSpacing.base() {
    return const AppSpacing(
      none: SpacingTokens.s0,
      xxs: SpacingTokens.s2,
      xs: SpacingTokens.s4,
      sm: SpacingTokens.s8,
      md: SpacingTokens.s12,
      lg: SpacingTokens.s16,
      xl: SpacingTokens.s24,
      x2l: SpacingTokens.s32,
      x3l: SpacingTokens.s48,
      x4l: SpacingTokens.s64,
      gutter: SpacingTokens.s16,
      pagePadding: SpacingTokens.s16,
      sectionGap: SpacingTokens.s24,
      itemGap: SpacingTokens.s12,
    );
  }

  AppSpacing copyWith({
    double? none,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? x2l,
    double? x3l,
    double? x4l,
    double? gutter,
    double? pagePadding,
    double? sectionGap,
    double? itemGap,
  }) {
    return AppSpacing(
      none: none ?? this.none,
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      x2l: x2l ?? this.x2l,
      x3l: x3l ?? this.x3l,
      x4l: x4l ?? this.x4l,
      gutter: gutter ?? this.gutter,
      pagePadding: pagePadding ?? this.pagePadding,
      sectionGap: sectionGap ?? this.sectionGap,
      itemGap: itemGap ?? this.itemGap,
    );
  }

  AppSpacing lerp(AppSpacing other, double t) {
    double l(double a, double b) => lerpDouble(a, b, t) ?? b;

    return AppSpacing(
      none: l(none, other.none),
      xxs: l(xxs, other.xxs),
      xs: l(xs, other.xs),
      sm: l(sm, other.sm),
      md: l(md, other.md),
      lg: l(lg, other.lg),
      xl: l(xl, other.xl),
      x2l: l(x2l, other.x2l),
      x3l: l(x3l, other.x3l),
      x4l: l(x4l, other.x4l),
      gutter: l(gutter, other.gutter),
      pagePadding: l(pagePadding, other.pagePadding),
      sectionGap: l(sectionGap, other.sectionGap),
      itemGap: l(itemGap, other.itemGap),
    );
  }
}
