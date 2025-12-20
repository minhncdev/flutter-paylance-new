/// Breakpoint primitive tokens (raw width in dp).
/// - Aligns with common responsive breakpoints for mobile/tablet/desktop.
/// - Layout layer decides how to use them (no layout logic here).
library;

import 'package:flutter/material.dart';

@immutable
class BreakpointTokens {
  /// Mobile baseline.
  static const double xs = 0;

  /// Compact tablet / large phones.
  static const double sm = 600;

  /// Tablet / small desktop.
  static const double md = 905;

  /// Desktop.
  static const double lg = 1240;

  /// Large desktop.
  static const double xl = 1440;

  const BreakpointTokens._();
}
