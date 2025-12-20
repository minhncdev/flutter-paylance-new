/// AppIcon: DS standardized icon renderer.
/// - Accepts a neutral IconSource (Material / SVG / Custom).
/// - Resolves size/color from Theme/DS if not provided.
/// - No hard-coded colors/sizes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'icon_source.dart';

@immutable
class AppIcon extends StatelessWidget {
  final IconSource source;

  /// Optional override. If null, resolves from IconTheme, then DS navigation icon size.
  final double? size;

  /// Optional override. If null, resolves from IconTheme, then ColorScheme.onSurfaceVariant.
  final Color? color;

  /// Optional semantics label. If null, defaults to null (decorative icon).
  final String? semanticsLabel;

  /// Whether to exclude from semantics (decorative). If [semanticsLabel] is provided, this is ignored.
  final bool excludeFromSemantics;

  const AppIcon(
    this.source, {
    super.key,
    this.size,
    this.color,
    this.semanticsLabel,
    this.excludeFromSemantics = true,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedSize = _resolveSize(context);
    final resolvedColor = _resolveColor(context);

    final bool isDecorative = semanticsLabel == null && excludeFromSemantics;

    final Widget iconWidget = switch (source) {
      MaterialIconSource(:final iconData) => Icon(
        iconData,
        size: resolvedSize,
        color: resolvedColor,
        semanticLabel: semanticsLabel,
      ),

      SvgAssetIconSource(:final assetName, :final package) => SvgPicture.asset(
        assetName,
        package: package,
        width: resolvedSize,
        height: resolvedSize,
        // Theme-driven coloring for monochrome SVGs.
        colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
        semanticsLabel: semanticsLabel,
        excludeFromSemantics: isDecorative,
      ),

      CustomIconSource(:final builder) => builder(
        context,
        resolvedSize,
        resolvedColor,
      ),
    };

    // If the custom builder doesn't provide semantics, we wrap it consistently.
    if (source is CustomIconSource) {
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: isDecorative,
        child: IconTheme.merge(
          data: IconThemeData(size: resolvedSize, color: resolvedColor),
          child: iconWidget,
        ),
      );
    }

    // Material Icon and SvgPicture already support semantics; still ensure decorative behavior.
    return isDecorative ? ExcludeSemantics(child: iconWidget) : iconWidget;
  }

  double _resolveSize(BuildContext context) {
    final iconThemeSize = IconTheme.of(context).size;
    if (size != null) return size!;
    if (iconThemeSize != null) return iconThemeSize;

    // DS fallback (token-driven) if IconTheme has no size.
    // Uses DS navigation metrics because it's a global, consistent icon size baseline.
    return context.dsComponents.navigation.navIconSize;
  }

  Color _resolveColor(BuildContext context) {
    final iconThemeColor = IconTheme.of(context).color;
    if (color != null) return color!;
    if (iconThemeColor != null) return iconThemeColor;

    // Theme-driven fallback.
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}
