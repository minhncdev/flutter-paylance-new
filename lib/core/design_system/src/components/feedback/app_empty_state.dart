/// DS EmptyState primitive.
/// - UI-only: displays icon/illustration, title, description, optional actions.
/// - Token/theme-driven spacing + typography + colors.
/// - Stateless.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

@immutable
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? description;

  /// Optional illustration/icon.
  final Widget? illustration;

  /// Optional primary/secondary actions (buttons provided by DS or app layer).
  final Widget? primaryAction;
  final Widget? secondaryAction;

  /// Alignment of content.
  final CrossAxisAlignment alignment;

  /// If true, center vertically.
  final bool centered;

  /// Optional semantics label override.
  final String? semanticsLabel;

  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.illustration,
    this.primaryAction,
    this.secondaryAction,
    this.alignment = CrossAxisAlignment.center,
    this.centered = false,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final s = context.dsSpacing.spacing;

    final content = Semantics(
      container: true,
      label: semanticsLabel ?? title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignment,
        children: <Widget>[
          if (illustration != null) ...[
            IconTheme.merge(
              data: IconThemeData(color: scheme.onSurfaceVariant),
              child: illustration!,
            ),
            SizedBox(height: s.lg),
          ],
          Text(title, style: t.titleLarge, textAlign: _textAlignFor(alignment)),
          if (description != null && description!.isNotEmpty) ...[
            SizedBox(height: s.sm),
            Text(
              description!,
              style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: _textAlignFor(alignment),
            ),
          ],
          if (primaryAction != null || secondaryAction != null) ...[
            SizedBox(height: s.xl),
            _ActionsRow(
              primary: primaryAction,
              secondary: secondaryAction,
              alignment: alignment,
            ),
          ],
        ],
      ),
    );

    if (!centered) return content;

    return Center(
      child: Padding(
        padding: context.dsSpacing.all(s.pagePadding),
        child: content,
      ),
    );
  }

  TextAlign _textAlignFor(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return TextAlign.start;
      case CrossAxisAlignment.end:
        return TextAlign.end;
      default:
        return TextAlign.center;
    }
  }
}

@immutable
class _ActionsRow extends StatelessWidget {
  final Widget? primary;
  final Widget? secondary;
  final CrossAxisAlignment alignment;

  const _ActionsRow({
    required this.primary,
    required this.secondary,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    // Avoid forcing layout direction; keep a simple, responsive-friendly column.
    // App layer can provide its own Row if needed.
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (primary != null) primary!,
        if (primary != null && secondary != null) SizedBox(height: s.sm),
        if (secondary != null) secondary!,
      ],
    );
  }
}
