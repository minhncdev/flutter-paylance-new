/// DS Bottom Navigation Bar primitive (custom implementation).
/// - No routing logic. Exposes selectedIndex + onSelected callback.
/// - Token/theme-driven via DS extensions + ColorScheme/TextTheme.
/// - Custom Row layout with GestureDetector (no ink effects).
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'navigation_item.dart';
import '_bottom_bar_item_view.dart';

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
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final int clampedIndex = selectedIndex.clamp(
      0,
      (items.isEmpty ? 0 : items.length - 1),
    );

    // IMPORTANT: reserve space for system navigation / home indicator.
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: Material(
        color: scheme.surface,
        child: SizedBox(
          // Total height includes safe-area inset.
          height: nav.bottomBarHeight + bottomInset,
          child: Padding(
            // Keep content in the top "nav.bottomBarHeight" region,
            // leave the bottomInset as empty safe space.
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < items.length; i++)
                  Expanded(
                    child: BottomBarItemView(
                      item: items[i],
                      selected: i == clampedIndex,
                      showLabel: showLabels,
                      onTap: items[i].enabled ? () => onSelected(i) : null,
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
