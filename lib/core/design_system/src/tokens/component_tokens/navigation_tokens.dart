/// Navigation primitive tokens (raw values only).
/// - AppBar / BottomBar / Tabs / NavigationRail raw metrics.
/// - No widgets, no padding objects.
library;

import 'package:flutter/material.dart';

import '../motion_tokens.dart'; // NEW
import '../size_tokens.dart';
import '../spacing_tokens.dart';

@immutable
class NavigationTokens {
  /// Material baseline AppBar height.
  static const double appBarHeight = 56;

  /// Bottom navigation bar height (comfortable for fintech).
  static const double bottomBarHeight = 52;

  /// Tab bar height.
  static const double tabBarHeight = 48;

  /// Navigation rail width (desktop/tablet).
  static const double navRailWidth = 80;

  /// Icon size in navigation items.
  static const double navIconSize = SizeTokens.sz24;

  /// Label/icon spacing within nav items.
  static const double itemGap = SpacingTokens.s6;

  /// Horizontal padding for nav item touch area (resolver decides final).
  static const double itemPaddingX = SpacingTokens.s12;

  // ===== NEW: BottomBar selected style =====
  /// Icon scale when selected/unselected.
  static const double bottomBarSelectedIconScale = 1.2;
  static const double bottomBarUnselectedIconScale = 1.0;

  /// Reduce icon vertical padding to 1px top/bottom.
  static const double bottomBarIconPaddingY = SpacingTokens.s2;

  /// Reduce label top padding to 1px.
  static const double bottomBarLabelPaddingTop = SpacingTokens.s1;

  // NEW: Reduce label bottom padding
  static const double bottomBarLabelPaddingBottom = SpacingTokens.s1;

  /// Scale animation duration.
  static const Duration bottomBarSelectionAnimDuration = MotionDurations.fast;

  // ===== BottomBar center action docking (for AppBottomBarWithCenterAction) =====

  /// Default FAB size used for the center action.
  static const double bottomBarCenterActionSize = SizeTokens.sz56;

  /// Horizontal breathing room around the center action (also used to reserve the dock gap).
  static const double bottomBarCenterActionDockPaddingX = SpacingTokens.s12;

  /// Distance from the bottom edge of the bar content (above safe area) to the FAB bottom.
  static const double bottomBarCenterActionBottomPadding = SpacingTokens.s8;

  // Center action border width (matches bottom bar background)
  static const double bottomBarCenterActionBorderWidth = SpacingTokens.s2;

  const NavigationTokens._();
}
