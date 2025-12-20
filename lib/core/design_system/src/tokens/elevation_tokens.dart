/// Elevation primitive tokens (raw dp values).
/// - No ThemeData usage here.
/// - Components/themes map these to Material 3 elevation behaviors at higher layers.
library;

import 'package:flutter/material.dart';

@immutable
class ElevationTokens {
  static const double e0 = 0;
  static const double e1 = 1;
  static const double e2 = 2;
  static const double e3 = 3;
  static const double e4 = 4;
  static const double e6 = 6;
  static const double e8 = 8;
  static const double e12 = 12;
  static const double e16 = 16;
  static const double e24 = 24;

  const ElevationTokens._();
}
