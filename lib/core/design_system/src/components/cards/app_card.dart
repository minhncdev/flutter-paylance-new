/// AppCard: token/theme-driven card primitive (Material 3 aligned).
/// - Supports variants (elevated/outlined/filled/surface).
/// - Optional header/footer with consistent spacing.
/// - No hard-coded colors/text styles/radii/insets.
/// - StatelessWidget by default.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'card_style_resolver.dart';
import 'card_variants.dart';

@immutable
class AppCard extends StatelessWidget {
  final Widget child;

  /// Optional header and footer widgets (e.g., title row, actions, summary).
  final Widget? header;
  final Widget? footer;

  final AppCardVariant variant;
  final AppCardPadding padding;

  /// Whether content should be clipped to the card radius.
  final Clip clipBehavior;

  /// Optional semantics label for accessibility grouping.
  final String? semanticsLabel;

  const AppCard({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.variant = AppCardVariant.surface,
    this.padding = AppCardPadding.md,
    this.clipBehavior = Clip.antiAlias,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = AppCardStyleResolver.resolve(
      context,
      variant: variant,
      padding: padding,
    );

    final border = resolved.borderSide != null
        ? Border.fromBorderSide(resolved.borderSide!)
        : null;

    // Compose header/body/footer with DS-driven gap.
    final content = _CardContent(
      header: header,
      child: child,
      footer: footer,
      padding: resolved.padding,
      gap: resolved.sectionGap,
    );

    final decorated = DecoratedBox(
      decoration: BoxDecoration(
        color: resolved.backgroundColor,
        borderRadius: resolved.borderRadius,
        border: border,
        boxShadow: resolved.shadows,
      ),
      child: clipBehavior == Clip.none
          ? content
          : ClipRRect(
              borderRadius: resolved.borderRadius,
              clipBehavior: clipBehavior,
              child: content,
            ),
    );

    // Semantics container helps screen readers treat the card as one group.
    return Semantics(container: true, label: semanticsLabel, child: decorated);
  }
}

@immutable
class _CardContent extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final EdgeInsets padding;
  final double gap;

  const _CardContent({
    required this.child,
    required this.header,
    required this.footer,
    required this.padding,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    final hasHeader = header != null;
    final hasFooter = footer != null;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (hasHeader) header!,
          if (hasHeader) SizedBox(height: gap),

          // Ensure body takes natural space and wraps.
          child,

          if (hasFooter) SizedBox(height: gap),
          if (hasFooter) footer!,

          // Keep a stable bottom baseline (no-op spacing from DS, avoids “random”).
          SizedBox(height: s.none),
        ],
      ),
    );
  }
}
