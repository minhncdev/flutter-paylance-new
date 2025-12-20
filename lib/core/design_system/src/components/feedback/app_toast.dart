/// DS Toast primitive (overlay-friendly).
/// - Does NOT show/hide itself. App layer controls visibility & overlay insertion.
/// - Token + theme driven for spacing/radii/elevation + motion tokens.
/// - Stateless: animations are driven by `visible` prop.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import '../../tokens/motion_tokens.dart';

enum AppToastPlacement { top, bottom }

enum AppToastTone { neutral, info, success, warning, danger }

@immutable
class AppToast extends StatelessWidget {
  final String? title;
  final String message;

  final IconData? icon;

  final AppToastTone tone;
  final AppToastPlacement placement;

  /// Visible state controlled by app layer.
  final bool visible;

  /// Optional trailing action widget (e.g., TextButton).
  final Widget? action;

  /// Optional close button callback (app layer orchestrates dismiss).
  final VoidCallback? onClose;

  /// Optional semantics label override.
  final String? semanticsLabel;

  const AppToast({
    super.key,
    this.title,
    required this.message,
    this.icon,
    this.tone = AppToastTone.neutral,
    this.placement = AppToastPlacement.bottom,
    this.visible = true,
    this.action,
    this.onClose,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final s = context.dsSpacing.spacing;

    final _ToneColors colors = _resolveTone(scheme, tone);

    // Use DS elevation tokens -> shadows (color from scheme.shadow).
    final shadows = context.dsElevation.shadowsFor(
      context.dsElevation.elevation.overlay,
      scheme.shadow,
    );

    final borderRadius = context.dsRadii.lg;

    // Motion: use tokens (duration + cubic from tokens).
    final duration = MotionDurations.fast;
    final curve = _cubicFromToken(EasingTokens.standard);

    // App controls `visible`; we animate appearance only.
    final offset = placement == AppToastPlacement.top ? -1.0 : 1.0;

    return Semantics(
      container: true,
      liveRegion: true,
      label: semanticsLabel ?? title ?? message,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: duration,
        curve: curve,
        child: AnimatedSlide(
          offset: visible ? Offset.zero : Offset(0, offset * 0.05),
          duration: duration,
          curve: curve,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: borderRadius,
              boxShadow: shadows,
            ),
            child: Padding(
              padding: context.dsSpacing.symmetric(
                horizontal: s.lg,
                vertical: s.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (icon != null) ...[
                    Icon(icon, color: colors.foreground),
                    SizedBox(width: s.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (title != null && title!.isNotEmpty) ...[
                          Text(
                            title!,
                            style: t.titleSmall?.copyWith(
                              color: colors.foreground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: s.xs),
                        ],
                        Text(
                          message,
                          style: t.bodyMedium?.copyWith(
                            color: colors.foreground,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (action != null) ...[
                          SizedBox(height: s.sm),
                          DefaultTextStyle.merge(
                            style: t.labelLarge?.copyWith(color: colors.action),
                            child: IconTheme.merge(
                              data: IconThemeData(color: colors.action),
                              child: action!,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onClose != null) ...[
                    SizedBox(width: s.sm),
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonTooltip,
                      onPressed: onClose,
                      icon: Icon(Icons.close, color: colors.foreground),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static _ToneColors _resolveTone(ColorScheme scheme, AppToastTone tone) {
    switch (tone) {
      case AppToastTone.neutral:
        return _ToneColors(
          background: scheme.inverseSurface,
          foreground: scheme.onInverseSurface,
          action: scheme.inversePrimary,
        );
      case AppToastTone.info:
        return _ToneColors(
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          action: scheme.primary,
        );
      case AppToastTone.success:
        return _ToneColors(
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
          action: scheme.secondary,
        );
      case AppToastTone.warning:
        return _ToneColors(
          background: scheme.tertiaryContainer,
          foreground: scheme.onTertiaryContainer,
          action: scheme.tertiary,
        );
      case AppToastTone.danger:
        return _ToneColors(
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
          action: scheme.error,
        );
    }
  }

  static Curve _cubicFromToken(CubicBezierToken token) {
    return Cubic(token.x1, token.y1, token.x2, token.y2);
    // Token-driven curve; no hard-coded Curves.*.
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
