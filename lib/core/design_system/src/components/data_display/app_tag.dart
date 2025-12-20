/// DS Tag primitive (small status/label pill).
/// - Token/theme-driven via ColorScheme + DS spacing/radii.
/// - No data formatting; just displays provided text.
/// - Stateless and list-friendly.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

enum AppTagTone { neutral, info, success, warning, danger }

@immutable
class AppTag extends StatelessWidget {
  final String label;
  final AppTagTone tone;

  final IconData? leadingIcon;

  /// Optional semantic label override.
  final String? semanticsLabel;

  const AppTag({
    super.key,
    required this.label,
    this.tone = AppTagTone.neutral,
    this.leadingIcon,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final s = context.dsSpacing.spacing;

    final _ToneColors c = _resolveTone(scheme, tone);

    return Semantics(
      label: semanticsLabel ?? label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: context.dsRadii.circular(context.dsRadii.shape.full),
        ),
        child: Padding(
          padding: context.dsSpacing.symmetric(
            horizontal: s.sm,
            vertical: s.xxs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: s.md, color: c.foreground),
                SizedBox(width: s.xs),
              ],
              Text(
                label,
                style: t.labelSmall?.copyWith(color: c.foreground),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ToneColors _resolveTone(ColorScheme scheme, AppTagTone tone) {
    switch (tone) {
      case AppTagTone.neutral:
        return _ToneColors(
          background: scheme.surfaceContainerHighest,
          foreground: scheme.onSurface,
        );
      case AppTagTone.info:
        return _ToneColors(
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
        );
      case AppTagTone.success:
        return _ToneColors(
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
        );
      case AppTagTone.warning:
        return _ToneColors(
          background: scheme.tertiaryContainer,
          foreground: scheme.onTertiaryContainer,
        );
      case AppTagTone.danger:
        return _ToneColors(
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
        );
    }
  }
}

@immutable
class _ToneColors {
  final Color background;
  final Color foreground;

  const _ToneColors({required this.background, required this.foreground});
}
