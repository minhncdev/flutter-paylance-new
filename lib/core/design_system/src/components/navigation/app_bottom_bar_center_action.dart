/// DS Bottom Navigation Bar variant with a centered action slot (FAB-like).
/// - Keep using [AppBottomBar] when you don't need a center action.
/// - App provides [centerAction] widget (FAB / custom button).
/// - Reserves a dock gap in the middle and overlays the center action via Stack.
/// - Optionally reserves bottom safe-area to avoid overlapping system gesture area.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'navigation_item.dart';
import '_bottom_bar_item_view.dart';

@immutable
class AppBottomBarCenterAction extends StatelessWidget {
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

  const AppBottomBarCenterAction({
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
    final scheme = Theme.of(context).colorScheme;

    final int clampedIndex = selectedIndex.clamp(
      0,
      (items.isEmpty ? 0 : items.length - 1),
    );

    final double bottomInset = reserveBottomSafeArea
        ? MediaQuery.viewPaddingOf(context).bottom
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
                          child: BottomBarItemView(
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
                          child: BottomBarItemView(
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

/// Backward-compatible alias (your ds_gallery may still use this).
@Deprecated('Use AppBottomBarCenterAction')
class AppBottomBarWithCenterAction extends AppBottomBarCenterAction {
  const AppBottomBarWithCenterAction({
    super.key,
    required super.items,
    required super.selectedIndex,
    required super.onSelected,
    required super.centerAction,
    super.centerActionSemanticsLabel,
    super.showLabels = true,
    super.semanticsLabel,
    super.reserveBottomSafeArea = true,
  });
}
