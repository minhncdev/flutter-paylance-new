/// DS Bottom Navigation Bar primitive (Material 3 NavigationBar).
/// - No routing logic. Exposes selectedIndex + onSelected callback.
/// - Token/theme-driven via DS extensions + ColorScheme/TextTheme.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'navigation_item.dart';

@immutable
class AppBottomBar extends StatelessWidget {
  final List<AppNavigationItem> items;

  /// Selected index managed by app layer.
  final int selectedIndex;

  /// App layer wiring (route changes) happens here.
  final ValueChanged<int> onSelected;

  /// Whether labels should be shown.
  final bool showLabels;

  /// Optional semantics label for accessibility grouping.
  final String? semanticsLabel;

  const AppBottomBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.showLabels = true,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final nav = context.dsComponents.navigation;
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: SizedBox(
        height: nav.bottomBarHeight,
        child: NavigationBar(
          selectedIndex: selectedIndex.clamp(
            0,
            (items.isEmpty ? 0 : items.length - 1),
          ),
          onDestinationSelected: (index) {
            if (index < 0 || index >= items.length) return;
            if (!items[index].enabled) return;
            onSelected(index);
          },
          labelBehavior: showLabels
              ? NavigationDestinationLabelBehavior.alwaysShow
              : NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            for (int i = 0; i < items.length; i++)
              _destinationFor(context, items[i], selected: i == selectedIndex),
          ],
        ),
      ),
    );
  }

  NavigationDestination _destinationFor(
    BuildContext context,
    AppNavigationItem item, {
    required bool selected,
  }) {
    final nav = context.dsComponents.navigation;

    return NavigationDestination(
      enabled: item.enabled,
      label: item.label,
      icon: _NavIconWithBadge(
        icon: item.iconForSelected(false),
        badge: item.badge,
        badgeCount: item.badgeCount,
        showBadgeWhenZero: item.showBadgeWhenZero,
        iconSize: nav.navIconSize,
        semanticsLabel: item.semanticsLabel ?? item.label,
      ),
      selectedIcon: _NavIconWithBadge(
        icon: item.iconForSelected(true),
        badge: item.badge,
        badgeCount: item.badgeCount,
        showBadgeWhenZero: item.showBadgeWhenZero,
        iconSize: nav.navIconSize,
        semanticsLabel: item.semanticsLabel ?? item.label,
      ),
    );
  }
}

@immutable
class _NavIconWithBadge extends StatelessWidget {
  final IconData icon;
  final double iconSize;

  final Widget? badge;
  final int? badgeCount;
  final bool showBadgeWhenZero;

  final String semanticsLabel;

  const _NavIconWithBadge({
    required this.icon,
    required this.iconSize,
    required this.badge,
    required this.badgeCount,
    required this.showBadgeWhenZero,
    required this.semanticsLabel,
  });

  bool get _hasBadge {
    if (badge != null) return true;
    if (badgeCount == null) return false;
    if (badgeCount! > 0) return true;
    return showBadgeWhenZero;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget iconWidget = Icon(icon, size: iconSize);

    if (!_hasBadge) {
      return Semantics(label: semanticsLabel, child: iconWidget);
    }

    return Semantics(
      label: semanticsLabel,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          iconWidget,
          Positioned(
            // Offset derived from DS spacing tokens.
            right: -(context.dsSpacing.spacing.xs),
            top: -(context.dsSpacing.spacing.xs),
            child:
                badge ??
                _DefaultBadge(
                  count: badgeCount,
                  showWhenZero: showBadgeWhenZero,
                ),
          ),
        ],
      ),
    );
  }
}

@immutable
class _DefaultBadge extends StatelessWidget {
  final int? count;
  final bool showWhenZero;

  const _DefaultBadge({required this.count, required this.showWhenZero});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final s = context.dsSpacing;

    final bool isDot = (count == null) || (count == 0 && showWhenZero);

    // Size/padding driven by DS spacing/radii (no hard-coded radius/EdgeInsets).
    final radius = context.dsRadii.shape.full;
    final bg = scheme.errorContainer;
    final fg = scheme.onErrorContainer;

    if (isDot) {
      final double dot = context.dsSpacing.spacing.sm;
      return Container(
        width: dot,
        height: dot,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: context.dsRadii.circular(radius),
        ),
      );
    }

    final String text = count! > 99 ? '99+' : '${count!}';

    return Container(
      padding: s.symmetric(
        horizontal: context.dsSpacing.spacing.xs,
        vertical: context.dsSpacing.spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: context.dsRadii.circular(radius),
      ),
      child: Text(text, style: textTheme.labelSmall?.copyWith(color: fg)),
    );
  }
}
