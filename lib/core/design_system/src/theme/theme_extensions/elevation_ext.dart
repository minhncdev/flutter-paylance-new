/// ThemeExtension wrapper for semantic elevation (AppElevation).
/// - Converts neutral shadow specs to BoxShadow using a provided color.
/// - Keeps shadow construction out of components.
library;

import 'package:flutter/material.dart';

import '../../foundations/app_elevation.dart';
import '../../tokens/shadow_tokens.dart';

@immutable
class DsElevationExt extends ThemeExtension<DsElevationExt> {
  final AppElevation elevation;

  const DsElevationExt({required this.elevation});

  @override
  DsElevationExt copyWith({AppElevation? elevation}) {
    return DsElevationExt(elevation: elevation ?? this.elevation);
  }

  @override
  DsElevationExt lerp(ThemeExtension<DsElevationExt>? other, double t) {
    if (other is! DsElevationExt) return this;
    return DsElevationExt(elevation: elevation.lerp(other.elevation, t));
  }

  /// Converts a semantic [ElevationSpec] into platform shadows using [shadowColor].
  /// Components should use this instead of constructing BoxShadow manually.
  List<BoxShadow> shadowsFor(ElevationSpec spec, Color shadowColor) {
    final layers = spec.shadow.layers;
    if (layers.isEmpty) return const <BoxShadow>[];

    return layers
        .map((ShadowLayerToken l) {
          return BoxShadow(
            color: shadowColor.withOpacity(l.opacity),
            offset: Offset(l.dx, l.dy),
            blurRadius: l.blur,
            spreadRadius: l.spread,
          );
        })
        .toList(growable: false);
  }
}
