/// Navigation primitive tokens (raw values only).
/// - AppBar / BottomBar / Tabs / NavigationRail raw metrics.
/// - No widgets, no padding objects.
library;

import 'package:flutter/material.dart';

import '../size_tokens.dart';
import '../spacing_tokens.dart';

@immutable
class NavigationTokens {
  /// Material baseline AppBar height.
  static const double appBarHeight = 56;

  /// Bottom navigation bar height (comfortable for fintech).
  static const double bottomBarHeight = 64;

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

  const NavigationTokens._();
}
