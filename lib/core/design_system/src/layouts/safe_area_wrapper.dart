/// Accessible SafeArea wrapper with DS-driven minimum padding.
/// - Uses SafeArea to respect notches/system UI.
/// - Adds optional DS spacing padding without scattering EdgeInsets.
library;

import 'package:flutter/material.dart';

import '../theme/theme_extensions/ds_extensions.dart';

@immutable
class SafeAreaWrapper extends StatelessWidget {
  final Widget child;

  /// Whether to apply SafeArea.
  final bool enabled;

  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  /// Optional minimum padding layered inside SafeArea.
  /// If null, no extra padding is added.
  final EdgeInsets? minimumPadding;

  const SafeAreaWrapper({
    super.key,
    required this.child,
    this.enabled = true,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimumPadding,
  });

  /// DS-friendly constructor for common usage:
  /// - Adds `pagePadding` as minimum padding inside SafeArea.
  factory SafeAreaWrapper.pagePadded({
    Key? key,
    required Widget child,
    bool enabled = true,
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeAreaWrapper(
      key: key,
      enabled: enabled,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Builder(
        builder: (context) {
          final s = context.dsSpacing.spacing;
          final pad = context.dsSpacing.symmetric(
            horizontal: s.pagePadding,
            vertical: s.none,
          );
          return SafeAreaWrapper(
            enabled: enabled,
            top: top,
            bottom: bottom,
            left: left,
            right: right,
            minimumPadding: pad,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget current = child;

    if (minimumPadding != null) {
      current = Padding(padding: minimumPadding!, child: current);
    }

    if (!enabled) return current;

    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: current,
    );
  }
}
