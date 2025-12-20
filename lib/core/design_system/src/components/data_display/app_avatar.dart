/// DS Avatar primitive.
/// - Displays image/initials/icon without business logic.
/// - Theme-driven colors, DS radii, DS spacing-based sizing.
/// - Stateless and grid/list friendly.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

enum AppAvatarSize { xs, sm, md, lg }

@immutable
class AppAvatar extends StatelessWidget {
  final AppAvatarSize size;

  /// If provided, image has priority.
  final ImageProvider? image;

  /// If provided and no image, displays initials (e.g., "AL").
  final String? initials;

  /// If provided and no image/initials, displays icon.
  final IconData? icon;

  /// Background override; if null uses theme surface variant.
  final Color? backgroundColor;

  /// Foreground override; if null uses theme onSurfaceVariant.
  final Color? foregroundColor;

  /// Optional semantic label.
  final String? semanticsLabel;

  const AppAvatar({
    super.key,
    this.size = AppAvatarSize.md,
    this.image,
    this.initials,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final s = context.dsSpacing.spacing;

    final double d = _diameterFor(size, s);
    final Color bg = backgroundColor ?? scheme.surfaceContainerHighest;
    final Color fg = foregroundColor ?? scheme.onSurfaceVariant;

    final Widget content = _buildContent(context, fg, t, d);

    return Semantics(
      image: image != null,
      label: semanticsLabel,
      child: Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: context.dsRadii.circular(context.dsRadii.shape.full),
        ),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        child: image != null
            ? Image(image: image!, width: d, height: d, fit: BoxFit.cover)
            : DefaultTextStyle.merge(
                style: t.labelLarge?.copyWith(color: fg),
                child: IconTheme.merge(
                  data: IconThemeData(color: fg, size: d * 0.5),
                  child: content,
                ),
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color fg, TextTheme t, double d) {
    if (initials != null && initials!.trim().isNotEmpty) {
      final String text = initials!.trim();
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style:
            (d >= context.dsSpacing.spacing.x3l ? t.titleMedium : t.labelLarge)
                ?.copyWith(color: fg),
      );
    }
    if (icon != null) {
      return Icon(icon);
    }
    // Fallback: generic person icon.
    return const Icon(Icons.person_outline);
  }

  double _diameterFor(AppAvatarSize size, dynamic spacing) {
    // Use DS spacing scale to avoid magic numbers.
    return switch (size) {
      AppAvatarSize.xs => spacing.xl as double,
      AppAvatarSize.sm => spacing.x2l as double,
      AppAvatarSize.md => spacing.x3l as double,
      AppAvatarSize.lg => spacing.x4l as double,
    };
  }
}
