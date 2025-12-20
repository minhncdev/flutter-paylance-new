/// Section layout primitive:
/// - Consistent vertical spacing, optional header (title/subtitle) + content.
/// - Uses DS spacing and Theme text styles (no hard-coded TextStyle).
library;

import 'package:flutter/material.dart';

import '../theme/theme_extensions/ds_extensions.dart';

@immutable
class Section extends StatelessWidget {
  final Widget child;

  final String? title;
  final String? subtitle;

  /// Optional leading/trailing widgets for header row.
  final Widget? leading;
  final Widget? trailing;

  /// Control spacing between header and body.
  final double? headerGap;

  /// Control outer spacing (vertical).
  final double? verticalPadding;

  const Section({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.headerGap,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    final outerV = verticalPadding ?? s.sectionGap;
    final gap = headerGap ?? s.md;

    final hasHeader =
        (title != null && title!.isNotEmpty) ||
        (subtitle != null && subtitle!.isNotEmpty) ||
        leading != null ||
        trailing != null;

    final header = hasHeader
        ? _SectionHeader(
            title: title,
            subtitle: subtitle,
            leading: leading,
            trailing: trailing,
          )
        : null;

    return Padding(
      padding: context.dsSpacing.vertical(outerV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (header != null) header,
          if (header != null) SizedBox(height: gap),
          child,
        ],
      ),
    );
  }
}

@immutable
class _SectionHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final theme = Theme.of(context);

    final titleText = (title != null && title!.isNotEmpty)
        ? Text(title!, style: theme.textTheme.titleLarge)
        : null;

    final subtitleText = (subtitle != null && subtitle!.isNotEmpty)
        ? Text(subtitle!, style: theme.textTheme.bodyMedium)
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (leading != null) leading!,
        if (leading != null) SizedBox(width: s.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (titleText != null) titleText,
              if (titleText != null && subtitleText != null)
                SizedBox(height: s.xs),
              if (subtitleText != null) subtitleText,
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[SizedBox(width: s.sm), trailing!],
      ],
    );
  }
}
