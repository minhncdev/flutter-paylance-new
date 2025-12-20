/// DS Alert Dialog primitive.
/// - UI-only: defines dialog structure, spacing, and theme-driven styling.
/// - No showDialog orchestration here; app layer calls showDialog.
/// - Supports variants + tone (neutral/info/success/warning/danger).
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'dialog_variants.dart';

@immutable
class AppAlertDialog extends StatelessWidget {
  final AppAlertDialogConfig config;

  final String? title;
  final Widget? titleWidget;

  final String? message;
  final Widget? content;

  /// Optional leading icon (if null, may be inferred from tone for some variants).
  final IconData? icon;

  /// Actions are provided as widgets (recommended: DS AppButton).
  final List<AppDialogAction> actions;

  /// Optional footer area (e.g., checkbox "Don't ask again").
  final Widget? footer;

  const AppAlertDialog({
    super.key,
    this.config = const AppAlertDialogConfig(),
    this.title,
    this.titleWidget,
    this.message,
    this.content,
    this.icon,
    this.actions = const <AppDialogAction>[],
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // Use DS card metrics for consistent radius/padding.
    final card = context.dsComponents.card;
    final radius = context.dsRadii.circular(card.radius);

    final shadows = context.dsElevation.shadowsFor(
      context.dsElevation.elevation.raised,
      scheme.shadow,
    );

    final Color bg = scheme.surface;
    final Color fg = scheme.onSurface;

    final tone = config.tone;
    final _ToneColors toneColors = _resolveTone(scheme, tone);

    final IconData? resolvedIcon = icon ?? _defaultIconFor(config);

    final Widget? header =
        (resolvedIcon != null ||
            titleWidget != null ||
            (title != null && title!.isNotEmpty))
        ? _DialogHeader(
            icon: resolvedIcon,
            title: title,
            titleWidget: titleWidget,
            tone: toneColors,
          )
        : null;

    final Widget? body =
        (content != null || (message != null && message!.isNotEmpty))
        ? _DialogBody(message: message, content: content)
        : null;

    final Widget? actionsArea = actions.isNotEmpty
        ? _DialogActions(actions: actions, stacked: config.actionsStacked)
        : null;

    return Semantics(
      container: true,
      label: config.semanticsLabel ?? title ?? message,
      child: Dialog(
        insetPadding: context.dsSpacing.all(s.pagePadding),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
            boxShadow: shadows,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: DefaultTextStyle.merge(
              style: t.bodyMedium?.copyWith(color: fg),
              child: Padding(
                padding: context.dsSpacing.all(card.paddingLg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (header != null) header,
                    if (header != null && body != null)
                      SizedBox(height: card.sectionGap),
                    if (body != null) body,
                    if (footer != null) ...[
                      SizedBox(height: card.sectionGap),
                      footer!,
                    ],
                    if (actionsArea != null) ...[
                      SizedBox(height: card.sectionGap),
                      actionsArea,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData? _defaultIconFor(AppAlertDialogConfig config) {
    // Only suggest icons for non-standard variants; keep standard minimal.
    switch (config.variant) {
      case AppAlertDialogVariant.standard:
        return null;
      case AppAlertDialogVariant.confirmation:
        switch (config.tone) {
          case AppDialogTone.success:
            return Icons.check_circle_outline;
          case AppDialogTone.info:
            return Icons.info_outline;
          case AppDialogTone.warning:
            return Icons.warning_amber_outlined;
          case AppDialogTone.danger:
            return Icons.error_outline;
          case AppDialogTone.neutral:
            return Icons.help_outline;
        }
      case AppAlertDialogVariant.destructive:
        return Icons.warning_amber_outlined;
    }
  }

  _ToneColors _resolveTone(ColorScheme scheme, AppDialogTone tone) {
    // Theme-driven: use M3 semantic containers.
    switch (tone) {
      case AppDialogTone.neutral:
        return _ToneColors(
          container: scheme.surfaceContainerHighest,
          onContainer: scheme.onSurface,
          accent: scheme.primary,
        );
      case AppDialogTone.info:
        return _ToneColors(
          container: scheme.primaryContainer,
          onContainer: scheme.onPrimaryContainer,
          accent: scheme.primary,
        );
      case AppDialogTone.success:
        return _ToneColors(
          container: scheme.secondaryContainer,
          onContainer: scheme.onSecondaryContainer,
          accent: scheme.secondary,
        );
      case AppDialogTone.warning:
        return _ToneColors(
          container: scheme.tertiaryContainer,
          onContainer: scheme.onTertiaryContainer,
          accent: scheme.tertiary,
        );
      case AppDialogTone.danger:
        return _ToneColors(
          container: scheme.errorContainer,
          onContainer: scheme.onErrorContainer,
          accent: scheme.error,
        );
    }
  }
}

@immutable
class _DialogHeader extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Widget? titleWidget;
  final _ToneColors tone;

  const _DialogHeader({
    required this.icon,
    required this.title,
    required this.titleWidget,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final t = Theme.of(context).textTheme;

    final Widget? titleNode =
        titleWidget ??
        (title != null && title!.isNotEmpty
            ? Text(
                title!,
                style: t.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (icon != null) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: tone.container,
              borderRadius: context.dsRadii.circular(
                context.dsRadii.shape.full,
              ),
            ),
            child: Padding(
              padding: context.dsSpacing.all(s.sm),
              child: Icon(icon, color: tone.onContainer),
            ),
          ),
          SizedBox(width: s.md),
        ],
        Expanded(child: titleNode ?? const SizedBox.shrink()),
      ],
    );
  }
}

@immutable
class _DialogBody extends StatelessWidget {
  final String? message;
  final Widget? content;

  const _DialogBody({required this.message, required this.content});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final s = context.dsSpacing.spacing;

    final Widget? messageNode = (message != null && message!.isNotEmpty)
        ? Text(
            message!,
            style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          )
        : null;

    final Widget? contentNode = content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (messageNode != null) messageNode,
        if (messageNode != null && contentNode != null) SizedBox(height: s.sm),
        if (contentNode != null) contentNode!,
      ],
    );
  }
}

@immutable
class _DialogActions extends StatelessWidget {
  final List<AppDialogAction> actions;
  final bool stacked;

  const _DialogActions({required this.actions, required this.stacked});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < actions.length; i++) ...[
            Semantics(
              button: true,
              label: actions[i].semanticsLabel,
              child: actions[i].child,
            ),
            if (i != actions.length - 1) SizedBox(height: s.sm),
          ],
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        for (int i = 0; i < actions.length; i++) ...[
          Semantics(
            button: true,
            label: actions[i].semanticsLabel,
            child: actions[i].child,
          ),
          if (i != actions.length - 1) SizedBox(width: s.sm),
        ],
      ],
    );
  }
}

@immutable
class _ToneColors {
  final Color container;
  final Color onContainer;
  final Color accent;

  const _ToneColors({
    required this.container,
    required this.onContainer,
    required this.accent,
  });
}
