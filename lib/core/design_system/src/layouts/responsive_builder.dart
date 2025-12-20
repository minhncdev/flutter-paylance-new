/// Responsive layout primitive.
/// - Uses DS breakpoint tokens to resolve layout tiers.
/// - No business logic; only layout branching.
library;

import 'package:flutter/material.dart';

import '../tokens/breakpoint_tokens.dart';

enum DsBreakpointTier { xs, sm, md, lg, xl }

@immutable
class DsResponsiveInfo {
  final DsBreakpointTier tier;
  final double width;
  final BoxConstraints constraints;

  const DsResponsiveInfo({
    required this.tier,
    required this.width,
    required this.constraints,
  });

  bool get isXs => tier == DsBreakpointTier.xs;
  bool get isSm => tier == DsBreakpointTier.sm;
  bool get isMd => tier == DsBreakpointTier.md;
  bool get isLg => tier == DsBreakpointTier.lg;
  bool get isXl => tier == DsBreakpointTier.xl;
}

DsBreakpointTier dsResolveBreakpointTier(double width) {
  // Uses DS tokens; tiers are inclusive by lower bound.
  if (width >= BreakpointTokens.xl) return DsBreakpointTier.xl;
  if (width >= BreakpointTokens.lg) return DsBreakpointTier.lg;
  if (width >= BreakpointTokens.md) return DsBreakpointTier.md;
  if (width >= BreakpointTokens.sm) return DsBreakpointTier.sm;
  return DsBreakpointTier.xs;
}

typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, DsResponsiveInfo info);

@immutable
class ResponsiveBuilder extends StatelessWidget {
  /// A single builder receives resolved tier + constraints.
  final ResponsiveWidgetBuilder builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final tier = dsResolveBreakpointTier(width);

        return builder(
          context,
          DsResponsiveInfo(tier: tier, width: width, constraints: constraints),
        );
      },
    );
  }
}

/// Convenience responsive switcher.
/// - Provide only what you need; falls back progressively.
@immutable
class ResponsiveSwitch extends StatelessWidget {
  final WidgetBuilder xs;
  final WidgetBuilder? sm;
  final WidgetBuilder? md;
  final WidgetBuilder? lg;
  final WidgetBuilder? xl;

  const ResponsiveSwitch({
    super.key,
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        switch (info.tier) {
          case DsBreakpointTier.xl:
            return (xl ?? lg ?? md ?? sm ?? xs)(context);
          case DsBreakpointTier.lg:
            return (lg ?? md ?? sm ?? xs)(context);
          case DsBreakpointTier.md:
            return (md ?? sm ?? xs)(context);
          case DsBreakpointTier.sm:
            return (sm ?? xs)(context);
          case DsBreakpointTier.xs:
            return xs(context);
        }
      },
    );
  }
}
