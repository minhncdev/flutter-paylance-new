/// DS context extensions.
/// - Convenience accessors for DS ThemeExtensions and common theme objects.
/// - No feature/app behavior. Pure getters/helpers.
library;

import 'package:flutter/material.dart';

import '../theme/theme_extensions/ds_extensions.dart';

extension DsContextX on BuildContext {
  /// Material theme.
  ThemeData get theme => Theme.of(this);

  /// Material 3 color scheme.
  ColorScheme get scheme => Theme.of(this).colorScheme;

  /// Material text theme (already mapped from DS typography in DS theme layer).
  TextTheme get text => Theme.of(this).textTheme;

  /// DS spacing extension.
  DsSpacingExt get dsSpacing => Theme.of(this).extension<DsSpacingExt>()!;

  /// DS radii extension.
  DsRadiiExt get dsRadii => Theme.of(this).extension<DsRadiiExt>()!;

  /// DS elevation extension.
  DsElevationExt get dsElevation => Theme.of(this).extension<DsElevationExt>()!;

  /// DS component styles/metrics extension.
  DsComponentStylesExt get dsComponents =>
      Theme.of(this).extension<DsComponentStylesExt>()!;
}
