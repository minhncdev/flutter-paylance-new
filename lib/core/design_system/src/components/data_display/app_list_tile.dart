/// DS ListTile primitive for dense data display.
/// - Compose-friendly: leading/title/subtitle/trailing.
/// - Token/theme-driven spacing + typography + colors.
/// - No routing/business logic; taps are callbacks.
/// - Designed for list/grid usage with predictable padding and density.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

enum AppListTileDensity { compact, standard }

@immutable
class AppListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final bool enabled;

  /// Optional selection highlight.
  final bool selected;

  /// Optional container style (like card-ish tiles).
  final bool useContainer;

  final AppListTileDensity density;

  /// Optional semantics label override.
  final String? semanticsLabel;

  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.useContainer = false,
    this.density = AppListTileDensity.standard,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = context.dsSpacing.spacing;

    final EdgeInsets padding = _paddingFor(context, density);

    final Color? containerColor = useContainer
        ? (selected ? scheme.secondaryContainer : scheme.surface)
        : null;

    final BorderRadius? radius = useContainer ? context.dsRadii.md : null;

    final Widget content = Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          if (leading != null) ...[leading!, SizedBox(width: s.md)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.bodyLarge,
                  child: title,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: s.xs),
                  DefaultTextStyle.merge(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: s.md), trailing!],
        ],
      ),
    );

    final Widget tappable = Material(
      color: containerColor ?? Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        borderRadius: radius,
        child: content,
      ),
    );

    return Semantics(
      enabled: enabled,
      selected: selected,
      label: semanticsLabel,
      child: tappable,
    );
  }

  EdgeInsets _paddingFor(BuildContext context, AppListTileDensity density) {
    final s = context.dsSpacing.spacing;

    // Use DS spacing; keep consistent across lists.
    switch (density) {
      case AppListTileDensity.compact:
        return context.dsSpacing.symmetric(horizontal: s.md, vertical: s.sm);
      case AppListTileDensity.standard:
        return context.dsSpacing.symmetric(horizontal: s.md, vertical: s.md);
    }
  }
}
