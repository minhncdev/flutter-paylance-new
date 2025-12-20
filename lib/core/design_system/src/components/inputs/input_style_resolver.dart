/// Input style resolver for DS inputs.
/// - Token + theme driven (ColorScheme/TextTheme + DS ThemeExtensions).
/// - Produces InputDecoration + constraints without business logic.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

enum AppInputSize { sm, md, lg }

@immutable
class AppInputResolved {
  final InputDecoration decoration;
  final BoxConstraints constraints;
  final double iconSize;

  const AppInputResolved({
    required this.decoration,
    required this.constraints,
    required this.iconSize,
  });
}

@immutable
class AppInputStyleResolver {
  const AppInputStyleResolver._();

  static AppInputResolved resolve(
    BuildContext context, {
    required AppInputSize size,
    required bool enabled,
    required String? labelText,
    required String? hintText,
    required String? helperText,
    required String? errorText,
    required Widget? prefixIcon,
    required Widget? suffixIcon,
    required bool isDense,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final metrics = context.dsComponents.input;
    final shape = context.dsRadii.shape;

    final height = _heightFor(size, metrics);
    final iconSize = metrics.iconSize;

    final contentPadding = context.dsSpacing.symmetric(
      horizontal: metrics.paddingX,
      vertical: metrics.paddingY,
    );

    // Token-driven border radius.
    final radius = context.dsRadii.circular(metrics.radius);

    // Token-driven borders.
    final enabledBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.outline, width: shape.strokeThin),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.primary, width: shape.strokeThick),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.error, width: shape.strokeThin),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: scheme.error, width: shape.strokeThick),
    );

    final disabledBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: scheme.outlineVariant,
        width: shape.strokeThin,
      ),
    );

    // Keep everything theme-driven: no custom TextStyle creation.
    final decoration = InputDecoration(
      isDense: isDense,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,

      // Icons are provided by caller (can be Icon with DS token size)
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,

      contentPadding: contentPadding,

      enabled: enabled,
      enabledBorder: enabledBorder,
      disabledBorder: disabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
    );

    return AppInputResolved(
      decoration: decoration,
      constraints: BoxConstraints(minHeight: height),
      iconSize: iconSize,
    );
  }

  static double _heightFor(AppInputSize size, dynamic metrics) {
    return switch (size) {
      AppInputSize.sm => metrics.heightSm as double,
      AppInputSize.md => metrics.heightMd as double,
      AppInputSize.lg => metrics.heightLg as double,
    };
  }

  static TextStyle? textStyleFor(
    BuildContext context, {
    required AppInputSize size,
  }) {
    final t = Theme.of(context).textTheme;
    return switch (size) {
      AppInputSize.sm => t.bodyMedium,
      AppInputSize.md => t.bodyLarge,
      AppInputSize.lg => t.bodyLarge,
    };
  }
}
