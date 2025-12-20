/// DS Snackbar primitive.
/// - UI-only: builds SnackBar using theme + DS spacing.
/// - Wrapper `show()` is allowed to call ScaffoldMessenger (explicit request exception).
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import '../../tokens/motion_tokens.dart';

enum AppFeedbackTone { neutral, info, success, warning, danger }

@immutable
class AppSnackBarData {
  final String message;

  final AppFeedbackTone tone;

  /// Optional leading icon for message context.
  final IconData? icon;

  /// Optional action.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Duration (token-driven default).
  final Duration? duration;

  /// Optional semantics label override.
  final String? semanticsLabel;

  const AppSnackBarData({
    required this.message,
    this.tone = AppFeedbackTone.neutral,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.duration,
    this.semanticsLabel,
  });
}

@immutable
class AppSnackBar {
  const AppSnackBar._();

  /// Build SnackBar (UI object) without showing it.
  static SnackBar build(BuildContext context, AppSnackBarData data) {
    final s = context.dsSpacing.spacing;
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final _ToneColors colors = _resolveTone(scheme, data.tone);

    final content = Semantics(
      container: true,
      liveRegion: true,
      label: data.semanticsLabel ?? data.message,
      child: Row(
        children: <Widget>[
          if (data.icon != null) ...[
            Icon(data.icon, color: colors.foreground),
            SizedBox(width: s.sm),
          ],
          Expanded(
            child: Text(
              data.message,
              style: t.bodyMedium?.copyWith(color: colors.foreground),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    final action = (data.actionLabel != null && data.onAction != null)
        ? SnackBarAction(
            label: data.actionLabel!,
            onPressed: data.onAction!,
            textColor: colors.action,
          )
        : null;

    return SnackBar(
      content: content,
      action: action,
      duration: data.duration ?? MotionDurations.medium,
      behavior: SnackBarBehavior.floating,
      backgroundColor: colors.background,
      showCloseIcon: false,
      margin: context.dsSpacing.all(s.md),
      padding: context.dsSpacing.symmetric(horizontal: s.lg, vertical: s.md),
    );
  }

  /// Snackbar wrapper (allowed to call ScaffoldMessenger).
  static void show(BuildContext context, AppSnackBarData data) {
    final snackBar = build(context, data);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static _ToneColors _resolveTone(ColorScheme scheme, AppFeedbackTone tone) {
    // Token/theme-driven mapping via Material 3 ColorScheme.
    switch (tone) {
      case AppFeedbackTone.neutral:
        return _ToneColors(
          background: scheme.inverseSurface,
          foreground: scheme.onInverseSurface,
          action: scheme.inversePrimary,
        );
      case AppFeedbackTone.info:
        return _ToneColors(
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          action: scheme.primary,
        );
      case AppFeedbackTone.success:
        return _ToneColors(
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
          action: scheme.secondary,
        );
      case AppFeedbackTone.warning:
        return _ToneColors(
          background: scheme.tertiaryContainer,
          foreground: scheme.onTertiaryContainer,
          action: scheme.tertiary,
        );
      case AppFeedbackTone.danger:
        return _ToneColors(
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
          action: scheme.error,
        );
    }
  }
}

@immutable
class _ToneColors {
  final Color background;
  final Color foreground;
  final Color action;

  const _ToneColors({
    required this.background,
    required this.foreground,
    required this.action,
  });
}
