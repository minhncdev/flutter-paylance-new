/// Neutral icon source model for DS.
/// - Supports Material icons, SVG assets, and custom-rendered icons.
/// - Does not encode routing/business logic.
/// - Rendering is handled by AppIcon.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Function signature for custom icon rendering.
/// - Receives resolved [size] + [color] from AppIcon to ensure theme-driven output.
typedef AppIconBuilder =
    Widget Function(BuildContext context, double size, Color color);

@immutable
sealed class IconSource {
  const IconSource();

  const factory IconSource.material(IconData iconData) = MaterialIconSource;

  /// SVG asset icon (requires `flutter_svg` in DS/app dependencies).
  /// - [assetName] should be a valid asset path.
  /// - [package] optional for package assets.
  const factory IconSource.svgAsset({
    required String assetName,
    String? package,
  }) = SvgAssetIconSource;

  /// Custom renderer (e.g., custom font glyph, inline painter, network svg wrapper, etc.).
  /// - Builder must respect the provided [size] and [color] for consistency.
  const factory IconSource.custom(AppIconBuilder builder) = CustomIconSource;
}

@immutable
final class MaterialIconSource extends IconSource {
  final IconData iconData;
  const MaterialIconSource(this.iconData);
}

@immutable
final class SvgAssetIconSource extends IconSource {
  final String assetName;
  final String? package;

  const SvgAssetIconSource({required this.assetName, this.package});
}

@immutable
final class CustomIconSource extends IconSource {
  final AppIconBuilder builder;
  const CustomIconSource(this.builder);
}
