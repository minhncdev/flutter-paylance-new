/// DS Bottom Navigation Bar variant with a centered action slot (FAB-like).
/// - Non-breaking: keep using [AppBottomBar] when you don't need a center action.
/// - App provides [centerAction] widget (FAB / custom button).
/// - Reserves a dock gap in the middle and overlays the center action via Stack.
/// - Optionally reserves bottom safe-area to avoid overlapping system gesture area.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'navigation_item.dart';

@immutable
class AppBottomBarWithCenterAction extends StatelessWidget {
  final List<AppNavigationItem> items;

  /// Selected index managed by app layer (index into [items]).
  final int selectedIndex;

  /// App layer wiring happens here.
  final ValueChanged<int> onSelected;

  /// Center action widget (e.g. FloatingActionButton).
  final Widget centerAction;

  /// Optional semantics label for the center action (if the widget doesn't provide one).
  final String? centerActionSemanticsLabel;

  /// Whether labels should be shown.
  final bool showLabels;

  /// Optional semantics label for accessibility grouping.
  final String? semanticsLabel;

  /// Reserve bottom safe-area inset (recommended when used as Scaffold.bottomNavigationBar).
  final bool reserveBottomSafeArea;

  const AppBottomBarWithCenterAction({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.centerAction,
    this.centerActionSemanticsLabel,
    this.showLabels = true,
    this.semanticsLabel,
    this.reserveBottomSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final nav = context.dsComponents.navigation;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final int clampedIndex = selectedIndex.clamp(
      0,
      (items.isEmpty ? 0 : items.length - 1),
    );

    final double bottomInset = reserveBottomSafeArea
        ? MediaQuery.of(context).viewPadding.bottom
        : 0;

    final double borderW = nav.bottomBarCenterActionBorderWidth;
    final double innerSize = nav.bottomBarCenterActionSize;
    final double outerSize = innerSize + (borderW * 2);

    final double dockWidth =
        outerSize + (nav.bottomBarCenterActionDockPaddingX * 2);

    // Split items into left/right groups; reserve the middle dock gap.
    final int leftCount = items.length ~/ 2;

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: Material(
        color: scheme.surface,
        child: SizedBox(
          height: nav.bottomBarHeight + bottomInset,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < leftCount; i++)
                        Expanded(
                          child: _BottomBarItem(
                            item: items[i],
                            selected: i == clampedIndex,
                            showLabel: showLabels,
                            onTap: items[i].enabled
                                ? () => onSelected(i)
                                : null,
                          ),
                        ),

                      // Dock gap for center action.
                      SizedBox(width: dockWidth),

                      for (int i = leftCount; i < items.length; i++)
                        Expanded(
                          child: _BottomBarItem(
                            item: items[i],
                            selected: i == clampedIndex,
                            showLabel: showLabels,
                            onTap: items[i].enabled
                                ? () => onSelected(i)
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Overlay center action (FAB)
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomInset + nav.bottomBarCenterActionBottomPadding,
                child: Center(
                  child: SizedBox.square(
                    dimension: outerSize,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(
                          side: BorderSide(
                            width: borderW,
                            color:
                                scheme.surface, // same as bottom bar background
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(borderW),
                        child: Center(
                          child: SizedBox.square(
                            dimension: innerSize,
                            child: centerActionSemanticsLabel == null
                                ? centerAction
                                : Semantics(
                                    button: true,
                                    label: centerActionSemanticsLabel,
                                    child: centerAction,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _BottomBarItem extends StatelessWidget {
  final AppNavigationItem item;
  final bool selected;
  final bool showLabel;
  final VoidCallback? onTap;

  const _BottomBarItem({
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
          child: Center(
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
