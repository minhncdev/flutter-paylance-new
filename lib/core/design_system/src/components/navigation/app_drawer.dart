/// DS Drawer primitive.
/// - No routing logic: emits selection callbacks only.
/// - Token/theme-driven with consistent spacing.
/// - Uses ListTiles as a simple, accessible navigation surface.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'navigation_item.dart';

@immutable
class AppDrawer extends StatelessWidget {
  final Widget? header;
  final Widget? footer;

  final List<AppNavigationItem> items;

  /// App-managed selection by id (recommended, stable across ordering changes).
  final String? selectedId;

  /// Callback to app layer (wire routing outside DS).
  final ValueChanged<AppNavigationItem> onSelected;

  /// Optional semantics label for the drawer.
  final String? semanticsLabel;

  const AppDrawer({
    super.key,
    this.header,
    this.footer,
    required this.items,
    required this.onSelected,
    this.selectedId,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              if (header != null)
                Padding(
                  padding: context.dsSpacing.all(s.pagePadding),
                  child: header!,
                ),
              Expanded(
                child: ListView.separated(
                  padding: context.dsSpacing.symmetric(
                    horizontal: s.pagePadding,
                    vertical: s.sm,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: s.xs),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final selected =
                        (selectedId != null && item.id == selectedId);

                    return _DrawerNavTile(
                      item: item,
                      selected: selected,
                      onTap: item.enabled ? () => onSelected(item) : null,
                    );
                  },
                ),
              ),
              if (footer != null)
                Padding(
                  padding: context.dsSpacing.all(s.pagePadding),
                  child: footer!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _DrawerNavTile extends StatelessWidget {
  final AppNavigationItem item;
  final bool selected;
  final VoidCallback? onTap;

  const _DrawerNavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final s = context.dsSpacing.spacing;

    final Color? tileColor = selected ? scheme.secondaryContainer : null;
    final Color? textColor = selected
        ? scheme.onSecondaryContainer
        : scheme.onSurface;

    return Material(
      color: tileColor,
      borderRadius: context.dsRadii.md,
      child: InkWell(
        onTap: onTap,
        borderRadius: context.dsRadii.md,
        child: Padding(
          padding: context.dsSpacing.symmetric(
            horizontal: s.md,
            vertical: s.sm,
          ),
          child: Row(
            children: <Widget>[
              Icon(item.iconForSelected(selected), color: textColor),
              SizedBox(width: s.md),
              Expanded(
                child: Text(
                  item.label,
                  style: textTheme.bodyLarge?.copyWith(color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.hasBadge) ...[
                SizedBox(width: s.sm),
                item.badge ??
                    _DrawerBadge(
                      count: item.badgeCount,
                      showWhenZero: item.showBadgeWhenZero,
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _DrawerBadge extends StatelessWidget {
  final int? count;
  final bool showWhenZero;

  const _DrawerBadge({required this.count, required this.showWhenZero});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bool isDot = (count == null) || (count == 0 && showWhenZero);
    final radius = context.dsRadii.shape.full;

    if (isDot) {
      final dot = context.dsSpacing.spacing.sm;
      return Container(
        width: dot,
        height: dot,
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: context.dsRadii.circular(radius),
        ),
      );
    }

    final text = count! > 99 ? '99+' : '${count!}';
    return Container(
      padding: context.dsSpacing.symmetric(
        horizontal: context.dsSpacing.spacing.xs,
        vertical: context.dsSpacing.spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: context.dsRadii.circular(radius),
      ),
      child: Text(
        text,
        style: textTheme.labelSmall?.copyWith(color: scheme.onErrorContainer),
      ),
    );
  }
}
