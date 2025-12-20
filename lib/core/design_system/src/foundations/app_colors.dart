/// Semantic color foundations (built from primitive palettes).
/// - Consumes only tokens (PrimitivePalettes/ColorScale).
/// - Exposes semantic roles for UI (no ThemeData / no ColorScheme here).
/// - Designed to be wrapped as ThemeExtension at theme layer.
library;

import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

import '../tokens/color_palette.dart';

@immutable
class BrandColorSelection {
  /// Which primitive scales this brand uses for key accents.
  /// Mapping to semantic roles happens in [AppColors.fromBrand].
  final ColorScale primary;
  final ColorScale secondary;
  final ColorScale accent;

  /// Status scales are usually shared across brands, but can be overridden.
  final ColorScale success;
  final ColorScale warning;
  final ColorScale danger;
  final ColorScale info;

  const BrandColorSelection({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
  });

  /// Default: uses base palettes (blue/teal/purple + standard status scales).
  static const BrandColorSelection base = BrandColorSelection(
    primary: PrimitivePalettes.base.blue,
    secondary: PrimitivePalettes.base.teal,
    accent: PrimitivePalettes.base.purple,
    success: PrimitivePalettes.base.green,
    warning: PrimitivePalettes.base.amber,
    danger: PrimitivePalettes.base.red,
    info: PrimitivePalettes.base.blue,
  );
}

/// Semantic colors for the app.
/// Keep this set stable and versioned for multi-team scalability.
@immutable
class AppColors {
  // Surfaces & backgrounds
  final Color background;
  final Color surface;
  final Color surfaceSubtle;
  final Color surfaceElevated;

  // Content
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color iconPrimary;
  final Color iconSecondary;

  // Borders & dividers
  final Color border;
  final Color divider;

  // Brand accents
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;

  final Color accent;
  final Color onAccent;

  // Status
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color danger;
  final Color onDanger;
  final Color dangerContainer;
  final Color onDangerContainer;

  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  // States
  final Color focusRing;
  final Color disabled;
  final Color onDisabled;

  // Scrims/overlays (raw colors; actual opacity usage belongs to UI/theme)
  final Color scrim;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceSubtle,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.border,
    required this.divider,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.accent,
    required this.onAccent,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.danger,
    required this.onDanger,
    required this.dangerContainer,
    required this.onDangerContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.focusRing,
    required this.disabled,
    required this.onDisabled,
    required this.scrim,
  });

  /// Brand-based semantic mapping for Light theme.
  factory AppColors.light({
    required PrimitivePalettes palettes,
    required BrandColorSelection brand,
  }) {
    final n = palettes.neutral;

    return AppColors(
      background: n[0],
      surface: n[0],
      surfaceSubtle: n[50],
      surfaceElevated: n[0],

      textPrimary: n[900],
      textSecondary: n[700],
      textTertiary: n[500],
      iconPrimary: n[800],
      iconSecondary: n[600],

      border: n[200],
      divider: n[200],

      primary: brand.primary[600],
      onPrimary: n[0],
      primaryContainer: brand.primary[100],
      onPrimaryContainer: brand.primary[900],

      secondary: brand.secondary[600],
      onSecondary: n[0],
      secondaryContainer: brand.secondary[100],
      onSecondaryContainer: brand.secondary[900],

      accent: brand.accent[600],
      onAccent: n[0],

      success: brand.success[600],
      onSuccess: n[0],
      successContainer: brand.success[100],
      onSuccessContainer: brand.success[900],

      warning: brand.warning[600],
      onWarning: n[950],
      warningContainer: brand.warning[100],
      onWarningContainer: brand.warning[900],

      danger: brand.danger[600],
      onDanger: n[0],
      dangerContainer: brand.danger[100],
      onDangerContainer: brand.danger[900],

      info: brand.info[600],
      onInfo: n[0],
      infoContainer: brand.info[100],
      onInfoContainer: brand.info[900],

      focusRing: brand.primary[600],
      disabled: n[200],
      onDisabled: n[500],

      scrim: n[950],
    );
  }

  /// Brand-based semantic mapping for Dark theme.
  factory AppColors.dark({
    required PrimitivePalettes palettes,
    required BrandColorSelection brand,
  }) {
    final n = palettes.neutral;

    return AppColors(
      background: n[950],
      surface: n[900],
      surfaceSubtle: n[900],
      surfaceElevated: n[800],

      textPrimary: n[50],
      textSecondary: n[200],
      textTertiary: n[400],
      iconPrimary: n[100],
      iconSecondary: n[300],

      border: n[700],
      divider: n[700],

      primary: brand.primary[400],
      onPrimary: n[950],
      primaryContainer: brand.primary[700],
      onPrimaryContainer: n[50],

      secondary: brand.secondary[400],
      onSecondary: n[950],
      secondaryContainer: brand.secondary[700],
      onSecondaryContainer: n[50],

      accent: brand.accent[400],
      onAccent: n[950],

      success: brand.success[400],
      onSuccess: n[950],
      successContainer: brand.success[700],
      onSuccessContainer: n[50],

      warning: brand.warning[400],
      onWarning: n[950],
      warningContainer: brand.warning[700],
      onWarningContainer: n[50],

      danger: brand.danger[400],
      onDanger: n[950],
      dangerContainer: brand.danger[700],
      onDangerContainer: n[50],

      info: brand.info[400],
      onInfo: n[950],
      infoContainer: brand.info[700],
      onInfoContainer: n[50],

      focusRing: brand.primary[400],
      disabled: n[800],
      onDisabled: n[500],

      scrim: n[950],
    );
  }

  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceSubtle,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? border,
    Color? divider,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? accent,
    Color? onAccent,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? danger,
    Color? onDanger,
    Color? dangerContainer,
    Color? onDangerContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? focusRing,
    Color? disabled,
    Color? onDisabled,
    Color? scrim,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      onDangerContainer: onDangerContainer ?? this.onDangerContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      focusRing: focusRing ?? this.focusRing,
      disabled: disabled ?? this.disabled,
      onDisabled: onDisabled ?? this.onDisabled,
      scrim: scrim ?? this.scrim,
    );
  }

  AppColors lerp(AppColors other, double t) {
    Color l(Color a, Color b) => Color.lerp(a, b, t) ?? b;

    return AppColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceSubtle: l(surfaceSubtle, other.surfaceSubtle),
      surfaceElevated: l(surfaceElevated, other.surfaceElevated),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      iconPrimary: l(iconPrimary, other.iconPrimary),
      iconSecondary: l(iconSecondary, other.iconSecondary),
      border: l(border, other.border),
      divider: l(divider, other.divider),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      primaryContainer: l(primaryContainer, other.primaryContainer),
      onPrimaryContainer: l(onPrimaryContainer, other.onPrimaryContainer),
      secondary: l(secondary, other.secondary),
      onSecondary: l(onSecondary, other.onSecondary),
      secondaryContainer: l(secondaryContainer, other.secondaryContainer),
      onSecondaryContainer: l(onSecondaryContainer, other.onSecondaryContainer),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      success: l(success, other.success),
      onSuccess: l(onSuccess, other.onSuccess),
      successContainer: l(successContainer, other.successContainer),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      warning: l(warning, other.warning),
      onWarning: l(onWarning, other.onWarning),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      danger: l(danger, other.danger),
      onDanger: l(onDanger, other.onDanger),
      dangerContainer: l(dangerContainer, other.dangerContainer),
      onDangerContainer: l(onDangerContainer, other.onDangerContainer),
      info: l(info, other.info),
      onInfo: l(onInfo, other.onInfo),
      infoContainer: l(infoContainer, other.infoContainer),
      onInfoContainer: l(onInfoContainer, other.onInfoContainer),
      focusRing: l(focusRing, other.focusRing),
      disabled: l(disabled, other.disabled),
      onDisabled: l(onDisabled, other.onDisabled),
      scrim: l(scrim, other.scrim),
    );
  }
}
