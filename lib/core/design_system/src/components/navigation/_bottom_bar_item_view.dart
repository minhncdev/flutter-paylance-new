/// Internal shared implementation for bottom bar items.
///
/// Used by:
/// - AppBottomBar
/// - AppBottomBarCenterAction (center action variant)
///
/// Not exported in design_system.dart on purpose.
library;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'navigation_item.dart';

@internal
@immutable
class BottomBarItemView extends StatelessWidget {
  final AppNavigationItem item;
  final bool selected;
  final bool showLabel;
  final VoidCallback? onTap;

  const BottomBarItemView({
    super.key,
    required this.item,
    required this.selected,
    required this.showLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nav = context.dsComponents.navigation;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool enabled = onTap != null;

    final Color fg = !enabled
        ? theme.disabledColor
        : (selected ? scheme.primary : scheme.onSurfaceVariant);

    final double scale = selected
        ? nav.bottomBarSelectedIconScale
        : nav.bottomBarUnselectedIconScale;

    final IconData resolvedIcon = item.iconForSelected(selected);

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: item.semanticsLabel ?? item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: context.dsSpacing.symmetric(horizontal: nav.itemPaddingX),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _NavIconWithBadge(
                  icon: resolvedIcon,
                  iconSize: nav.navIconSize,
                  color: fg,
                  scale: scale,
                  scaleAnimDuration: nav.bottomBarSelectionAnimDuration,
                  iconPaddingY: nav.bottomBarIconPaddingY,
                  badge: item.badge,
                  badgeCount: item.badgeCount,
                  showBadgeWhenZero: item.showBadgeWhenZero,
                ),
                if (showLabel)
                  Padding(
                    padding: context.dsSpacing.only(
                      top: nav.bottomBarLabelPaddingTop,
                      bottom: nav.bottomBarLabelPaddingBottom,
                    ),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(color: fg),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _NavIconWithBadge extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color color;

  final double scale;
  final Duration scaleAnimDuration;
  final double iconPaddingY;

  final Widget? badge;
  final int? badgeCount;
  final bool showBadgeWhenZero;

  const _NavIconWithBadge({
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.scale,
    required this.scaleAnimDuration,
    required this.iconPaddingY,
    required this.badge,
    required this.badgeCount,
    required this.showBadgeWhenZero,
  });

  bool get _hasBadge {
    if (badge != null) return true;
    if (badgeCount == null) return false;
    if (badgeCount! > 0) return true;
    return showBadgeWhenZero;
  }

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = Padding(
      padding: context.dsSpacing.only(top: iconPaddingY, bottom: iconPaddingY),
      child: AnimatedScale(
        scale: scale,
        duration: scaleAnimDuration,
        curve: Curves.easeOut,
        child: Icon(icon, size: iconSize, color: color),
      ),
    );

    if (!_hasBadge) return ExcludeSemantics(child: iconWidget);

    return ExcludeSemantics(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          iconWidget,
          Positioned(
            right: -(context.dsSpacing.spacing.xs),
            top: -(context.dsSpacing.spacing.xs),
            child:
                badge ??
                _DefaultBadge(
                  count: badgeCount,
                  showWhenZero: showBadgeWhenZero, // ✅ đúng tên param
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
