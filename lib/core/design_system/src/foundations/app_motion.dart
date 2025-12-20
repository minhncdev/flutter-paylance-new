/// Semantic motion foundations (no Curve objects).
/// - Consumes motion tokens (durations + cubic bezier params).
/// - Exposes semantic motion presets used by components/themes.
/// - Theme layer can map cubic-bezier params into Curves.
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import '../tokens/motion_tokens.dart';

@immutable
class MotionSpec {
  final Duration duration;
  final CubicBezierToken easing;

  const MotionSpec({required this.duration, required this.easing});

  MotionSpec copyWith({Duration? duration, CubicBezierToken? easing}) {
    return MotionSpec(
      duration: duration ?? this.duration,
      easing: easing ?? this.easing,
    );
  }

  MotionSpec lerp(MotionSpec other, double t) {
    int lerpMs(int a, int b) => (a + ((b - a) * t)).round();

    return MotionSpec(
      duration: Duration(
        milliseconds: lerpMs(
          duration.inMilliseconds,
          other.duration.inMilliseconds,
        ),
      ),
      easing: t < 0.5 ? easing : other.easing,
    );
  }
}

@immutable
class AppMotion {
  /// Micro-interactions (press, small fades).
  final MotionSpec micro;

  /// Default transitions (most navigation & state changes).
  final MotionSpec standard;

  /// Emphasized transitions (dialogs, sheets, prominent reveals).
  final MotionSpec emphasized;

  const AppMotion({
    required this.micro,
    required this.standard,
    required this.emphasized,
  });

  factory AppMotion.base() {
    return const AppMotion(
      micro: MotionSpec(
        duration: MotionDurations.fast,
        easing: EasingTokens.standard,
      ),
      standard: MotionSpec(
        duration: MotionDurations.medium,
        easing: EasingTokens.standard,
      ),
      emphasized: MotionSpec(
        duration: MotionDurations.slow,
        easing: EasingTokens.emphasized,
      ),
    );
  }

  AppMotion copyWith({
    MotionSpec? micro,
    MotionSpec? standard,
    MotionSpec? emphasized,
  }) {
    return AppMotion(
      micro: micro ?? this.micro,
      standard: standard ?? this.standard,
      emphasized: emphasized ?? this.emphasized,
    );
  }

  AppMotion lerp(AppMotion other, double t) {
    return AppMotion(
      micro: micro.lerp(other.micro, t),
      standard: standard.lerp(other.standard, t),
      emphasized: emphasized.lerp(other.emphasized, t),
    );
  }
}
