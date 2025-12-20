/// DS ThemeExtensions aggregator + BuildContext accessors.
/// - Centralizes DS API retrieval from ThemeData.extensions.
/// - Keeps component code clean: context.dsSpacing / context.dsRadii / etc.
library;

import 'package:flutter/material.dart';

import 'component_styles_ext.dart';
import 'elevation_ext.dart';
import 'radii_ext.dart';
import 'spacing_ext.dart';

@immutable
class DsTheme {
  final DsSpacingExt spacing;
  final DsRadiiExt radii;
  final DsElevationExt elevation;
  final DsComponentStylesExt components;

  const DsTheme({
    required this.spacing,
    required this.radii,
    required this.elevation,
    required this.components,
  });
}

extension DsThemeContextX on BuildContext {
  ThemeData get _theme => Theme.of(this);

  DsSpacingExt get dsSpacing {
    final ext = _theme.extension<DsSpacingExt>();
    assert(
      ext != null,
      'DsSpacingExt is not registered in ThemeData.extensions',
    );
    return ext!;
  }

  DsRadiiExt get dsRadii {
    final ext = _theme.extension<DsRadiiExt>();
    assert(ext != null, 'DsRadiiExt is not registered in ThemeData.extensions');
    return ext!;
  }

  DsElevationExt get dsElevation {
    final ext = _theme.extension<DsElevationExt>();
    assert(
      ext != null,
      'DsElevationExt is not registered in ThemeData.extensions',
    );
    return ext!;
  }

  DsComponentStylesExt get dsComponents {
    final ext = _theme.extension<DsComponentStylesExt>();
    assert(
      ext != null,
      'DsComponentStylesExt is not registered in ThemeData.extensions',
    );
    return ext!;
  }

  /// Convenience to access all DS extensions at once.
  DsTheme get ds => DsTheme(
    spacing: dsSpacing,
    radii: dsRadii,
    elevation: dsElevation,
    components: dsComponents,
  );
}
