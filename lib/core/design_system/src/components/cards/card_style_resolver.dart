/// Resolves token/theme-driven styles for DS cards.
/// - Uses Material 3 ColorScheme + DS ThemeExtensions (spacing/radii/elevation/component metrics).
/// - No hard-coded colors, radii, or insets.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'card_variants.dart';

@immutable
class AppCardResolvedStyle {
  final Color backgroundColor;
  final BorderRadius borderRadius;

  /// Null means no border.
  final BorderSide? borderSide;

  /// Already converted to BoxShadow using DS elevation + theme shadow color.
  final List<BoxShadow> shadows;

  /// Consistent padding derived from DS component tokens + DS spacing helpers.
  final EdgeInsets padding;

  /// Gap between header/body/footer sections.
  final double sectionGap;

  const AppCardResolvedStyle({
    required this.backgroundColor,
    required this.borderRadius,
    required this.borderSide,
    required this.shadows,
    required this.padding,
    required this.sectionGap,
  });
}

@immutable
class AppCardStyleResolver {
  const AppCardStyleResolver._();

  static AppCardResolvedStyle resolve(
    BuildContext context, {
    required AppCardVariant variant,
    required AppCardPadding padding,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final cardMetrics = context.dsComponents.card;
    final shape = context.dsRadii.shape;

    // Radius is resolved from DS radii extension (token-driven).
    final borderRadius = context.dsRadii.circular(cardMetrics.radius);

    // Padding is centralized through DS spacing helper (no scattered EdgeInsets).
    final double padValue = switch (padding) {
      AppCardPadding.sm => cardMetrics.paddingSm,
      AppCardPadding.md => cardMetrics.paddingMd,
      AppCardPadding.lg => cardMetrics.paddingLg,
    };
    final EdgeInsets resolvedPadding = context.dsSpacing.all(padValue);

    final double gap = cardMetrics.sectionGap;

    // Background/border/shadow per variant using ColorScheme + DS elevation.
    switch (variant) {
      case AppCardVariant.elevated:
        final shadows = context.dsElevation.shadowsFor(
          context.dsElevation.elevation.raised,
          scheme.shadow,
        );
        return AppCardResolvedStyle(
          backgroundColor: scheme.surface,
          borderRadius: borderRadius,
          borderSide: null,
          shadows: shadows,
          padding: resolvedPadding,
          sectionGap: gap,
        );

      case AppCardVariant.outlined:
        return AppCardResolvedStyle(
          backgroundColor: scheme.surface,
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: scheme.outline,
            width: shape.strokeThin,
          ),
          shadows: const <BoxShadow>[],
          padding: resolvedPadding,
          sectionGap: gap,
        );

      case AppCardVariant.filled:
        return AppCardResolvedStyle(
          backgroundColor: scheme.surfaceContainerHighest,
          borderRadius: borderRadius,
          borderSide: null,
          shadows: const <BoxShadow>[],
          padding: resolvedPadding,
          sectionGap: gap,
        );

      case AppCardVariant.surface:
        return AppCardResolvedStyle(
          backgroundColor: scheme.surface,
          borderRadius: borderRadius,
          borderSide: null,
          shadows: const <BoxShadow>[],
          padding: resolvedPadding,
          sectionGap: gap,
        );
    }
  }
}
