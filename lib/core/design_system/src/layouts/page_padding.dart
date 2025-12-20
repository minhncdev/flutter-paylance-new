/// Page padding primitive:
/// - Applies DS page padding consistently.
/// - Adds optional centered max content width for larger screens.
/// - No business logic; purely layout.
library;

import 'package:flutter/material.dart';

import '../theme/theme_extensions/ds_extensions.dart';
import '../tokens/breakpoint_tokens.dart';
import 'responsive_builder.dart';

@immutable
class PagePadding extends StatelessWidget {
  final Widget child;

  /// If true, center content on wide screens with a max width.
  final bool centerContent;

  /// Optional max content width. If null, uses DS breakpoint defaults.
  final double? maxContentWidth;

  /// Whether to apply vertical padding (usually pages want horizontal only).
  final bool includeVerticalPadding;

  const PagePadding({
    super.key,
    required this.child,
    this.centerContent = true,
    this.maxContentWidth,
    this.includeVerticalPadding = false,
  });

  double _defaultMaxWidthForTier(DsBreakpointTier tier) {
    // Conservative defaults, aligned with DS breakpoint tiers.
    // These are layout constraints (not “style”); kept centralized here.
    switch (tier) {
      case DsBreakpointTier.xs:
      case DsBreakpointTier.sm:
        return double.infinity;
      case DsBreakpointTier.md:
        return BreakpointTokens.lg;
      case DsBreakpointTier.lg:
      case DsBreakpointTier.xl:
        return BreakpointTokens.lg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    final horizontal = s.pagePadding;
    final vertical = includeVerticalPadding ? s.pagePadding : s.none;

    final basePadding = context.dsSpacing.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    );

    if (!centerContent) {
      return Padding(padding: basePadding, child: child);
    }

    return ResponsiveBuilder(
      builder: (context, info) {
        final limit = maxContentWidth ?? _defaultMaxWidthForTier(info.tier);

        return Padding(
          padding: basePadding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: limit),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
