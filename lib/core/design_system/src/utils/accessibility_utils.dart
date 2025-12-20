/// Accessibility utilities for DS.
/// - Pure helpers: text scaling, contrast-aware choices, semantics-friendly defaults.
/// - No platform services and no orchestration.
library;

import 'package:flutter/material.dart';

@immutable
class AccessibilityUtils {
  const AccessibilityUtils._();

  /// Returns true if user has a large text scale factor enabled.
  static bool isLargeText(BuildContext context, {double threshold = 1.2}) {
    final scale = MediaQuery.textScaleFactorOf(context);
    return scale >= threshold;
  }

  /// Clamps text scale to avoid layout overflow for certain compact UI elements.
  /// - Use sparingly; should not globally reduce accessibility.
  static double clampedTextScale(
    BuildContext context, {
    double min = 1.0,
    double max = 1.4,
  }) {
    final scale = MediaQuery.textScaleFactorOf(context);
    return scale.clamp(min, max);
  }

  /// Builds a Text widget that respects max lines/overflow and uses provided style from theme.
  /// - Helper to keep consistent overflow handling.
  static Widget ellipsizedText(
    String text, {
    required TextStyle? style,
    int maxLines = 1,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// Picks between two colors based on which has better contrast with a background.
  /// - Uses relative luminance heuristic, not a full WCAG contrast calc (fast & sufficient for UI decisions).
  static Color pickForegroundForBackground({
    required Color background,
    required Color lightForeground,
    required Color darkForeground,
  }) {
    // Relative luminance in Flutter: 0 (dark) .. 1 (light)
    final lum = background.computeLuminance();
    return lum > 0.5 ? darkForeground : lightForeground;
  }

  /// Wraps a widget with semantics container and optional label/hint.
  static Widget semanticsContainer({
    required Widget child,
    String? label,
    String? hint,
    bool liveRegion = false,
    bool button = false,
    bool enabled = true,
    bool selected = false,
  }) {
    return Semantics(
      container: true,
      label: label,
      hint: hint,
      liveRegion: liveRegion,
      button: button,
      enabled: enabled,
      selected: selected,
      child: child,
    );
  }
}
