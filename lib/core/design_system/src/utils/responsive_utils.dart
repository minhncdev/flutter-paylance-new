/// Responsive utilities for DS.
/// - Pure helpers based on DS breakpoint tokens + MediaQuery.
/// - No business logic, no routing, no feature dependencies.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/breakpoint_tokens.dart';
import '../layouts/responsive_builder.dart';

@immutable
class ResponsiveUtils {
  const ResponsiveUtils._();

  /// Returns the current viewport width.
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  /// Returns the current viewport height.
  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Resolves DS breakpoint tier from current MediaQuery width.
  static DsBreakpointTier tier(BuildContext context) =>
      dsResolveBreakpointTier(width(context));

  static bool isXs(BuildContext context) =>
      tier(context) == DsBreakpointTier.xs;
  static bool isSm(BuildContext context) =>
      tier(context) == DsBreakpointTier.sm;
  static bool isMd(BuildContext context) =>
      tier(context) == DsBreakpointTier.md;
  static bool isLg(BuildContext context) =>
      tier(context) == DsBreakpointTier.lg;
  static bool isXl(BuildContext context) =>
      tier(context) == DsBreakpointTier.xl;

  /// Common layout rule: treat md+ as "desktop/tablet wide" breakpoint.
  static bool isWide(BuildContext context) =>
      width(context) >= BreakpointTokens.md;

  /// Returns a max content width suggestion (layout-only helper).
  /// - Uses DS breakpoints, no hard-coded numbers beyond tokens.
  static double suggestedMaxContentWidth(BuildContext context) {
    final w = width(context);
    if (w >= BreakpointTokens.lg) return BreakpointTokens.lg;
    if (w >= BreakpointTokens.md) return BreakpointTokens.md;
    return double.infinity;
  }

  /// Returns responsive value by tier with graceful fallback.
  static T byTier<T>(
    BuildContext context, {
    required T xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
  }) {
    final t = tier(context);
    switch (t) {
      case DsBreakpointTier.xl:
        return xl ?? lg ?? md ?? sm ?? xs;
      case DsBreakpointTier.lg:
        return lg ?? md ?? sm ?? xs;
      case DsBreakpointTier.md:
        return md ?? sm ?? xs;
      case DsBreakpointTier.sm:
        return sm ?? xs;
      case DsBreakpointTier.xs:
        return xs;
    }
  }
}
