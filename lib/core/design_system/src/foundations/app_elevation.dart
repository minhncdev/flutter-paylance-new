/// Semantic elevation foundations (no BoxShadow).
/// - Consumes elevation + shadow tokens.
/// - Exposes semantic elevation levels with neutral shadow specs.
/// - Theme layer decides actual shadow color for light/dark/brand.
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../tokens/elevation_tokens.dart';
import '../tokens/shadow_tokens.dart';

@immutable
class ElevationSpec {
  final double elevationDp;

  /// Neutral shadow description (no color / no BoxShadow).
  final ShadowToken shadow;

  const ElevationSpec({required this.elevationDp, required this.shadow});

  ElevationSpec copyWith({double? elevationDp, ShadowToken? shadow}) {
    return ElevationSpec(
      elevationDp: elevationDp ?? this.elevationDp,
      shadow: shadow ?? this.shadow,
    );
  }

  ElevationSpec lerp(ElevationSpec other, double t) {
    return ElevationSpec(
      elevationDp:
          lerpDouble(elevationDp, other.elevationDp, t) ?? other.elevationDp,
      shadow: t < 0.5 ? shadow : other.shadow,
    );
  }
}

/// App elevation contract for components.
/// Keep it small and consistent to avoid fragmented elevation usage.
@immutable
class AppElevation {
  final ElevationSpec none;
  final ElevationSpec raised;
  final ElevationSpec floating;
  final ElevationSpec overlay;

  const AppElevation({
    required this.none,
    required this.raised,
    required this.floating,
    required this.overlay,
  });

  factory AppElevation.base() {
    return const AppElevation(
      none: ElevationSpec(
        elevationDp: ElevationTokens.e0,
        shadow: ShadowTokens.s0,
      ),
      raised: ElevationSpec(
        elevationDp: ElevationTokens.e2,
        shadow: ShadowTokens.s1,
      ),
      floating: ElevationSpec(
        elevationDp: ElevationTokens.e6,
        shadow: ShadowTokens.s3,
      ),
      overlay: ElevationSpec(
        elevationDp: ElevationTokens.e12,
        shadow: ShadowTokens.s4,
      ),
    );
  }

  AppElevation copyWith({
    ElevationSpec? none,
    ElevationSpec? raised,
    ElevationSpec? floating,
    ElevationSpec? overlay,
  }) {
    return AppElevation(
      none: none ?? this.none,
      raised: raised ?? this.raised,
      floating: floating ?? this.floating,
      overlay: overlay ?? this.overlay,
    );
  }

  AppElevation lerp(AppElevation other, double t) {
    return AppElevation(
      none: none.lerp(other.none, t),
      raised: raised.lerp(other.raised, t),
      floating: floating.lerp(other.floating, t),
      overlay: overlay.lerp(other.overlay, t),
    );
  }
}
