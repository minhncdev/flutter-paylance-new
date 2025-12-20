/// DS Loading primitive.
/// - UI-only; no orchestration/timers.
/// - Token/theme-driven spacing + typography; uses Material 3 progress indicator.
/// - Stateless.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

enum AppLoadingSize { sm, md, lg }

@immutable
class AppLoading extends StatelessWidget {
  final AppLoadingSize size;

  /// Optional label below indicator.
  final String? label;

  /// If true, center within available space.
  final bool centered;

  /// Optional semantics label override.
  final String? semanticsLabel;

  const AppLoading({
    super.key,
    this.size = AppLoadingSize.md,
    this.label,
    this.centered = false,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final s = context.dsSpacing.spacing;
    final shape = context.dsRadii.shape;

    final double indicator = _indicatorSize(context, size);

    final content = Semantics(
      container: true,
      label:
          semanticsLabel ??
          label ??
          MaterialLocalizations.of(context).searchFieldLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: indicator,
            height: indicator,
            child: CircularProgressIndicator(
              strokeWidth: shape.strokeThin,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
          if (label != null && label!.isNotEmpty) ...[
            SizedBox(height: s.md),
            Text(label!, style: t.bodyMedium),
          ],
        ],
      ),
    );

    if (!centered) return content;

    return Center(child: content);
  }

  double _indicatorSize(BuildContext context, AppLoadingSize size) {
    // Use DS size/spacing scale instead of magic numbers.
    final sp = context.dsSpacing.spacing;
    switch (size) {
      case AppLoadingSize.sm:
        return sp.xl;
      case AppLoadingSize.md:
        return sp.x2l;
      case AppLoadingSize.lg:
        return sp.x3l;
    }
  }
}
