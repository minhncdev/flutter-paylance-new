/// DS Bottom Sheet primitive.
/// - UI-only: defines sheet structure with token/theme-driven spacing and shape.
/// - App layer calls showModalBottomSheet.
/// - Supports variants (standard/action) + optional drag handle/header/footer.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'dialog_variants.dart';

@immutable
class AppBottomSheet extends StatelessWidget {
  final AppBottomSheetConfig config;

  final String? title;
  final Widget? titleWidget;

  /// Optional description under title (UI only).
  final String? subtitle;

  /// Main content/body.
  final Widget child;

  /// Optional footer (e.g., action buttons).
  final Widget? footer;

  /// Optional leading widget (e.g., icon).
  final Widget? leading;

  const AppBottomSheet({
    super.key,
    this.config = const AppBottomSheetConfig(),
    this.title,
    this.titleWidget,
    this.subtitle,
    required this.child,
    this.footer,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final s = context.dsSpacing.spacing;

    final card = context.dsComponents.card;
    final radiusTop = Radius.circular(card.radius);

    final Widget? header =
        (config.showDragHandle ||
            leading != null ||
            titleWidget != null ||
            (title != null && title!.isNotEmpty) ||
            (subtitle != null && subtitle!.isNotEmpty))
        ? _SheetHeader(
            showDragHandle: config.showDragHandle,
            leading: leading,
            title: title,
            titleWidget: titleWidget,
            subtitle: subtitle,
          )
        : null;

    final Widget body = switch (config.variant) {
      AppBottomSheetVariant.standard => child,
      AppBottomSheetVariant.action => _ActionSheetBody(child: child),
    };

    return Semantics(
      container: true,
      label: config.semanticsLabel ?? title ?? subtitle,
      child: Material(
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: radiusTop,
            topRight: radiusTop,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: context.dsSpacing.only(
              left: s.pagePadding,
              right: s.pagePadding,
              bottom: s.pagePadding,
              top: s.md,
            ),
            child: DefaultTextStyle.merge(
              style: t.bodyMedium?.copyWith(color: scheme.onSurface),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (header != null) header,
                  if (header != null) SizedBox(height: card.sectionGap),
                  Flexible(child: body),
                  if (footer != null) ...[
                    SizedBox(height: card.sectionGap),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _SheetHeader extends StatelessWidget {
  final bool showDragHandle;
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;

  const _SheetHeader({
    required this.showDragHandle,
    required this.leading,
    required this.title,
    required this.titleWidget,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final scheme = Theme.of(context).colorScheme;
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

    final Widget? subtitleNode = (subtitle != null && subtitle!.isNotEmpty)
        ? Text(
            subtitle!,
            style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (showDragHandle) ...[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: s.x3l,
              height: s.xs,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: context.dsRadii.circular(
                  context.dsRadii.shape.full,
                ),
              ),
            ),
          ),
          SizedBox(height: s.md),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (leading != null) ...[leading!, SizedBox(width: s.md)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (titleNode != null) titleNode,
                  if (titleNode != null && subtitleNode != null)
                    SizedBox(height: s.xs),
                  if (subtitleNode != null) subtitleNode,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

@immutable
class _ActionSheetBody extends StatelessWidget {
  final Widget child;

  const _ActionSheetBody({required this.child});

  @override
  Widget build(BuildContext context) {
    // Action sheet is usually a list of actions; keep content scroll-friendly.
    final s = context.dsSpacing.spacing;

    return Padding(
      padding: context.dsSpacing.only(top: s.xs),
      child: child,
    );
  }
}
