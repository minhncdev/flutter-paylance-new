/// Shadow primitive tokens expressed as neutral specs (no BoxShadow).
/// - Theme layer can convert these specs into platform shadows with a chosen color.
/// - Keeping color out helps multi-brand and light/dark adaptation.
library;

import 'package:flutter/material.dart';

@immutable
class ShadowLayerToken {
  final double dx;
  final double dy;
  final double blur;
  final double spread;

  /// Opacity to apply on the chosen shadow color at higher layers.
  final double opacity;

  const ShadowLayerToken({
    required this.dx,
    required this.dy,
    required this.blur,
    required this.spread,
    required this.opacity,
  });
}

@immutable
class ShadowToken {
  final List<ShadowLayerToken> layers;

  const ShadowToken(this.layers);
}

/// A small, consistent shadow scale.
/// Values are neutral and can be tuned to match your brand direction.
@immutable
class ShadowTokens {
  static const ShadowToken s0 = ShadowToken(<ShadowLayerToken>[]);

  /// Subtle shadow (elevation ~1-2).
  static const ShadowToken s1 = ShadowToken(<ShadowLayerToken>[
    ShadowLayerToken(dx: 0, dy: 1, blur: 2, spread: 0, opacity: 0.12),
    ShadowLayerToken(dx: 0, dy: 1, blur: 1, spread: 0, opacity: 0.08),
  ]);

  /// Medium shadow (elevation ~3-4).
  static const ShadowToken s2 = ShadowToken(<ShadowLayerToken>[
    ShadowLayerToken(dx: 0, dy: 2, blur: 6, spread: -1, opacity: 0.14),
    ShadowLayerToken(dx: 0, dy: 1, blur: 3, spread: 0, opacity: 0.10),
  ]);

  /// Stronger shadow (elevation ~6-8).
  static const ShadowToken s3 = ShadowToken(<ShadowLayerToken>[
    ShadowLayerToken(dx: 0, dy: 6, blur: 14, spread: -4, opacity: 0.16),
    ShadowLayerToken(dx: 0, dy: 2, blur: 6, spread: -1, opacity: 0.12),
  ]);

  /// Overlay/Modal shadow (elevation ~12-16).
  static const ShadowToken s4 = ShadowToken(<ShadowLayerToken>[
    ShadowLayerToken(dx: 0, dy: 12, blur: 28, spread: -8, opacity: 0.18),
    ShadowLayerToken(dx: 0, dy: 4, blur: 10, spread: -2, opacity: 0.14),
  ]);

  const ShadowTokens._();
}
