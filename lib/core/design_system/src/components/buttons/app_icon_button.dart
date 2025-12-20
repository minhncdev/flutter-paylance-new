/// AppIconButton: token/theme-driven icon-only button.
/// - Shares the same variant/size/state model with AppButton.
/// - No hard-coded colors/insets; uses DS ThemeExtensions and ColorScheme.
/// - StatelessWidget by default.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'button_style_resolver.dart';
import 'button_variants.dart';

@immutable
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final AppButtonState state;

  final VoidCallback? onPressed;

  /// Accessibility label is required for icon-only buttons.
  final String semanticsLabel;

  const AppIconButton({
    super.key,
    required this.icon,
    this.variant = AppButtonVariant.ghost,
    this.size = AppButtonSize.md,
    this.state = const AppButtonState(),
    required this.onPressed,
    required this.semanticsLabel,
  });

  bool get _isInteractable =>
      onPressed != null && state.enabled && !state.loading;

  @override
  Widget build(BuildContext context) {
    final m = context.dsComponents.button;

    final iconSize = switch (size) {
      AppButtonSize.sm => m.iconSm,
      AppButtonSize.md => m.iconMd,
      AppButtonSize.lg => m.iconLg,
    };

    final style = AppButtonStyleResolver.resolveIconButtonStyle(
      context,
      variant: variant,
      size: size,
      state: state,
    );

    final Widget content = state.loading
        ? _LoadingIndicator(size: iconSize)
        : Icon(icon, size: iconSize);

    return Semantics(
      button: true,
      enabled: _isInteractable,
      label: semanticsLabel,
      child: IconButton(
        onPressed: _isInteractable ? onPressed : null,
        style: style,
        icon: content,
        tooltip: semanticsLabel,
      ),
    );
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
        valueColor: AlwaysStoppedAnimation<Color>(scheme.onSurface),
      ),
    );
  }
}
