/// App-level helpers for positioning FAB consistently with DS tokens.
///
/// Keep this in app/ (not in DS) because:
/// - which pages show FAB is app-specific
/// - positioning can vary per feature/page
library;

import 'package:flutter/widgets.dart';

import '../core/design_system/design_system.dart';

class AppFabOffsets {
  /// When your bottom bar reserves safe-area itself (like AppBottomBar),
  /// Scaffold may place FAB higher than expected because it uses the full
  /// bottomNavigationBar height (including the safe inset).
  ///
  /// This returns a downward compensation (in pixels) you can apply via
  /// Transform.translate to visually align FAB closer to the bar.
  static double bottomBarSafeAreaCompensation(BuildContext context) {
    return MediaQuery.viewPaddingOf(context).bottom;
  }

  /// Optional extra lift above the bottom bar area (token-driven).
  static double extraLift(BuildContext context) {
    return context.dsSpacing.spacing.sm;
  }
}
