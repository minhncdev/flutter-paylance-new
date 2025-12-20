/// Resolves token-driven ButtonStyle for DS buttons.
/// - Uses Material 3 ColorScheme/TextTheme + DS ThemeExtensions (spacing/radii/component metrics/elevation).
/// - No hard-coded colors, text styles, or scattered EdgeInsets.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import '../../tokens/opacity_tokens.dart';
import 'button_variants.dart';

@immutable
class AppButtonStyleResolver {
  const AppButtonStyleResolver._();

  static ButtonStyle resolveButtonStyle(
    BuildContext context, {
    required AppButtonVariant variant,
    required AppButtonSize size,
    required AppButtonState state,
    bool iconOnly = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final metrics = context.dsComponents.button;
    final shape = context.dsRadii.shape;

    final resolved = _resolveColors(scheme, variant);

    final EdgeInsets padding = _resolvePadding(context, size, iconOnly);
    final Size minSize = _resolveMinSize(metrics, size, iconOnly);

    final BorderRadius borderRadius = _resolveRadius(context, size);

    final TextStyle? textStyle = _resolveTextStyle(theme.textTheme, size);

    final double elevationDp = _resolveElevationDp(context, variant);

    final BorderSide? side = _resolveSide(
      scheme: scheme,
      variant: variant,
      strokeWidth: shape.strokeThin,
      enabled: state.enabled && !state.loading,
    );

    return ButtonStyle(
      // Layout
      minimumSize: MaterialStatePropertyAll<Size>(minSize),
      padding: MaterialStatePropertyAll<EdgeInsets>(padding),
      shape: MaterialStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,

      // Typography
      textStyle: textStyle != null
          ? MaterialStatePropertyAll<TextStyle>(textStyle)
          : null,

      // Colors & states
      backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.disabled)) {
          return resolved.disabledBackground;
        }
        return resolved.background;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.disabled)) {
          return resolved.disabledForeground;
        }
        return resolved.foreground;
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.pressed))
          return resolved.pressedOverlay;
        if (states.contains(MaterialState.hovered))
          return resolved.hoverOverlay;
        if (states.contains(MaterialState.focused))
          return resolved.focusOverlay;
        return null;
      }),

      // Border
      side: side != null ? MaterialStatePropertyAll<BorderSide>(side) : null,

      // Elevation
      elevation: MaterialStateProperty.resolveWith<double>((states) {
        if (states.contains(MaterialState.disabled)) return 0;
        if (variant == AppButtonVariant.ghost ||
            variant == AppButtonVariant.outline)
          return 0;
        return elevationDp;
      }),
      shadowColor: MaterialStatePropertyAll<Color>(scheme.shadow),
      surfaceTintColor: MaterialStatePropertyAll<Color>(scheme.surfaceTint),
    );
  }

  static ButtonStyle resolveIconButtonStyle(
    BuildContext context, {
    required AppButtonVariant variant,
    required AppButtonSize size,
    required AppButtonState state,
  }) {
    // Icon buttons are treated as iconOnly buttons using the same resolver,
    // but we ensure a square minSize.
    return resolveButtonStyle(
      context,
      variant: variant,
      size: size,
      state: state,
      iconOnly: true,
    );
  }

  static _ResolvedColors _resolveColors(
    ColorScheme scheme,
    AppButtonVariant variant,
  ) {
    // Variant base colors from ColorScheme (semantic mapping already token-driven).
    switch (variant) {
      case AppButtonVariant.primary:
        return _ResolvedColors(
          background: scheme.primary,
          foreground: scheme.onPrimary,
          disabledBackground: scheme.onSurface.withOpacity(OpacityTokens.o12),
          disabledForeground: scheme.onSurface.withOpacity(OpacityTokens.o40),
          pressedOverlay: scheme.onPrimary.withOpacity(OpacityTokens.o12),
          hoverOverlay: scheme.onPrimary.withOpacity(OpacityTokens.o8),
          focusOverlay: scheme.onPrimary.withOpacity(OpacityTokens.o12),
        );
      case AppButtonVariant.secondary:
        return _ResolvedColors(
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
          disabledBackground: scheme.onSurface.withOpacity(OpacityTokens.o12),
          disabledForeground: scheme.onSurface.withOpacity(OpacityTokens.o40),
          pressedOverlay: scheme.onSecondaryContainer.withOpacity(
            OpacityTokens.o12,
          ),
          hoverOverlay: scheme.onSecondaryContainer.withOpacity(
            OpacityTokens.o8,
          ),
          focusOverlay: scheme.onSecondaryContainer.withOpacity(
            OpacityTokens.o12,
          ),
        );
      case AppButtonVariant.tonal:
        return _ResolvedColors(
          background: scheme.surfaceContainerHighest,
          foreground: scheme.onSurface,
          disabledBackground: scheme.onSurface.withOpacity(OpacityTokens.o12),
          disabledForeground: scheme.onSurface.withOpacity(OpacityTokens.o40),
          pressedOverlay: scheme.onSurface.withOpacity(OpacityTokens.o12),
          hoverOverlay: scheme.onSurface.withOpacity(OpacityTokens.o8),
          focusOverlay: scheme.onSurface.withOpacity(OpacityTokens.o12),
        );
      case AppButtonVariant.outline:
        return _ResolvedColors(
          background: Colors.transparent,
          foreground: scheme.primary,
          disabledBackground: Colors.transparent,
          disabledForeground: scheme.onSurface.withOpacity(OpacityTokens.o40),
          pressedOverlay: scheme.primary.withOpacity(OpacityTokens.o12),
          hoverOverlay: scheme.primary.withOpacity(OpacityTokens.o8),
          focusOverlay: scheme.primary.withOpacity(OpacityTokens.o12),
        );
      case AppButtonVariant.ghost:
        return _ResolvedColors(
          background: Colors.transparent,
          foreground: scheme.onSurface,
          disabledBackground: Colors.transparent,
          disabledForeground: scheme.onSurface.withOpacity(OpacityTokens.o40),
          pressedOverlay: scheme.onSurface.withOpacity(OpacityTokens.o12),
          hoverOverlay: scheme.onSurface.withOpacity(OpacityTokens.o8),
          focusOverlay: scheme.onSurface.withOpacity(OpacityTokens.o12),
        );
      case AppButtonVariant.danger:
        return _ResolvedColors(
          background: scheme.error,
          foreground: scheme.onError,
          disabledBackground: scheme.onSurface.withOpacity(OpacityTokens.o12),
          disabledForeground: scheme.onSurface.withOpacity(OpacityTokens.o40),
          pressedOverlay: scheme.onError.withOpacity(OpacityTokens.o12),
          hoverOverlay: scheme.onError.withOpacity(OpacityTokens.o8),
          focusOverlay: scheme.onError.withOpacity(OpacityTokens.o12),
        );
    }
  }

  static BorderSide? _resolveSide({
    required ColorScheme scheme,
    required AppButtonVariant variant,
    required double strokeWidth,
    required bool enabled,
  }) {
    if (variant != AppButtonVariant.outline) return null;

    final color = enabled
        ? scheme.outline
        : scheme.onSurface.withOpacity(OpacityTokens.o24);
    return BorderSide(color: color, width: strokeWidth);
  }

  static EdgeInsets _resolvePadding(
    BuildContext context,
    AppButtonSize size,
    bool iconOnly,
  ) {
    final s = context.dsSpacing;
    final m = context.dsComponents.button;

    if (iconOnly) {
      // Square icon-only buttons should be comfortably padded.
      final v = switch (size) {
        AppButtonSize.sm => m.paddingYSm,
        AppButtonSize.md => m.paddingYMd,
        AppButtonSize.lg => m.paddingYLg,
      };
      return s.all(v);
    }

    final (px, py) = switch (size) {
      AppButtonSize.sm => (m.paddingXSm, m.paddingYSm),
      AppButtonSize.md => (m.paddingXMd, m.paddingYMd),
      AppButtonSize.lg => (m.paddingXLg, m.paddingYLg),
    };

    return s.symmetric(horizontal: px, vertical: py);
  }

  static Size _resolveMinSize(
    dynamic metrics,
    AppButtonSize size,
    bool iconOnly,
  ) {
    final h = switch (size) {
      AppButtonSize.sm => metrics.heightSm as double,
      AppButtonSize.md => metrics.heightMd as double,
      AppButtonSize.lg => metrics.heightLg as double,
    };

    // For icon-only, enforce square.
    if (iconOnly) return Size(h, h);

    return Size(0, h);
  }

  static BorderRadius _resolveRadius(BuildContext context, AppButtonSize size) {
    final m = context.dsComponents.button;

    final r = switch (size) {
      AppButtonSize.sm => m.radiusSm,
      AppButtonSize.md => m.radiusMd,
      AppButtonSize.lg => m.radiusLg,
    };

    return context.dsRadii.circular(r);
  }

  static TextStyle? _resolveTextStyle(TextTheme textTheme, AppButtonSize size) {
    // Use theme roles; no TextStyle construction.
    return switch (size) {
      AppButtonSize.sm => textTheme.labelMedium,
      AppButtonSize.md => textTheme.labelLarge,
      AppButtonSize.lg => textTheme.labelLarge,
    };
  }

  static double _resolveElevationDp(
    BuildContext context,
    AppButtonVariant variant,
  ) {
    // Token-driven semantic elevation from DS extensions.
    // For filled variants, use "raised"; for others, 0.
    if (variant == AppButtonVariant.primary ||
        variant == AppButtonVariant.danger) {
      return context.dsElevation.elevation.raised.elevationDp;
    }
    if (variant == AppButtonVariant.secondary ||
        variant == AppButtonVariant.tonal) {
      return context.dsElevation.elevation.none.elevationDp;
    }
    return 0;
  }
}

@immutable
class _ResolvedColors {
  final Color background;
  final Color foreground;

  final Color disabledBackground;
  final Color disabledForeground;

  final Color pressedOverlay;
  final Color hoverOverlay;
  final Color focusOverlay;

  const _ResolvedColors({
    required this.background,
    required this.foreground,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.pressedOverlay,
    required this.hoverOverlay,
    required this.focusOverlay,
  });
}
