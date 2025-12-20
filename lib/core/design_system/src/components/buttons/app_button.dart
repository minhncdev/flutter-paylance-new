/// AppButton: token/theme-driven button primitive (Material 3 aligned).
/// - Supports variant, size, and state (enabled/loading).
/// - No hard-coded colors/text styles/insets; all from Theme + DS extensions.
/// - StatelessWidget by default.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'button_style_resolver.dart';
import 'button_variants.dart';

typedef AppButtonCallback = Future<void> Function();

@immutable
class AppButton extends StatelessWidget {
  final String label;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Optional trailing icon.
  final IconData? trailingIcon;

  final AppButtonVariant variant;
  final AppButtonSize size;

  /// State flags (enabled/loading).
  final AppButtonState state;

  /// If true, button expands to full available width.
  final bool fullWidth;

  /// Callback. If null => disabled. If state.enabled=false/loading=true => disabled.
  final VoidCallback? onPressed;

  /// Accessibility: override semantics label (defaults to [label]).
  final String? semanticsLabel;

  const AppButton({
    super.key,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.state = const AppButtonState(),
    this.fullWidth = false,
    required this.onPressed,
    this.semanticsLabel,
  });

  bool get _isInteractable =>
      onPressed != null && state.enabled && !state.loading;

  @override
  Widget build(BuildContext context) {
    final style = AppButtonStyleResolver.resolveButtonStyle(
      context,
      variant: variant,
      size: size,
      state: state,
      iconOnly: false,
    );

    final Widget child = _ButtonContent(
      label: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      size: size,
      loading: state.loading,
    );

    final Widget button = _buildMaterialButton(
      context,
      style: style,
      child: child,
      onPressed: _isInteractable ? onPressed : null,
    );

    final Widget wrapped = Semantics(
      button: true,
      enabled: _isInteractable,
      label: semanticsLabel ?? label,
      child: button,
    );

    if (!fullWidth) return wrapped;

    return SizedBox(width: double.infinity, child: wrapped);
  }

  Widget _buildMaterialButton(
    BuildContext context, {
    required ButtonStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    // Choose underlying Material 3 button family based on variant.
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
        return FilledButton(onPressed: onPressed, style: style, child: child);

      case AppButtonVariant.secondary:
      case AppButtonVariant.tonal:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: style,
          child: child,
        );

      case AppButtonVariant.outline:
        return OutlinedButton(onPressed: onPressed, style: style, child: child);

      case AppButtonVariant.ghost:
        return TextButton(onPressed: onPressed, style: style, child: child);
    }
  }
}

@immutable
class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final AppButtonSize size;
  final bool loading;

  const _ButtonContent({
    required this.label,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.size,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = context.dsComponents.button;
    final s = context.dsSpacing.spacing;

    final iconSize = switch (size) {
      AppButtonSize.sm => m.iconSm,
      AppButtonSize.md => m.iconMd,
      AppButtonSize.lg => m.iconLg,
    };

    final gap = m.contentGap;

    final Widget labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      // Use theme typography (no TextStyle creation).
      style: switch (size) {
        AppButtonSize.sm => theme.textTheme.labelMedium,
        AppButtonSize.md => theme.textTheme.labelLarge,
        AppButtonSize.lg => theme.textTheme.labelLarge,
      },
    );

    final Widget? leading = _buildLeading(context, iconSize);
    final Widget? trailing = _buildTrailing(context, iconSize);

    // Keep layout stable when loading: show progress in place of leading icon.
    final Widget? effectiveLeading = loading
        ? _LoadingIndicator(size: iconSize)
        : leading;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (effectiveLeading != null) effectiveLeading,
        if (effectiveLeading != null) SizedBox(width: gap),
        Flexible(child: labelWidget),
        if (trailing != null) SizedBox(width: gap),
        if (trailing != null) trailing,
        // Optional small spacing to avoid cramped content on very small widths.
        if (!loading && leading == null && trailing == null)
          SizedBox(width: s.none),
      ],
    );
  }

  Widget? _buildLeading(BuildContext context, double iconSize) {
    if (leadingIcon == null) return null;
    return Icon(leadingIcon, size: iconSize);
  }

  Widget? _buildTrailing(BuildContext context, double iconSize) {
    if (trailingIcon == null) return null;
    return Icon(trailingIcon, size: iconSize);
  }
}

@immutable
class _LoadingIndicator extends StatelessWidget {
  final double size;

  const _LoadingIndicator({required this.size});

  @override
  Widget build(BuildContext context) {
    final shape = context.dsRadii.shape;
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: shape.strokeThin,
        // Use theme colors (no hard-coded color).
        valueColor: AlwaysStoppedAnimation<Color>(scheme.onPrimary),
      ),
    );
  }
}
