/// Corner radius primitive tokens (no BorderRadius).
/// - Keep a small set to reduce visual inconsistency across components.
library;

import 'package:flutter/material.dart';

@immutable
class RadiusTokens {
  static const double r0 = 0;
  static const double r2 = 2;
  static const double r4 = 4;
  static const double r6 = 6;
  static const double r8 = 8;
  static const double r12 = 12;
  static const double r16 = 16;
  static const double r20 = 20;
  static const double r24 = 24;
  static const double r32 = 32;

  /// Large value used for pills/circles when needed.
  static const double rFull = 999;

  const RadiusTokens._();
}
