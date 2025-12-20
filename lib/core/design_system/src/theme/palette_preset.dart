// core/design_system/src/theme/palette_preset.dart
//
// PalettePreset describes a selectable palette "preset" for DS theme building.
// - Token-driven: references PrimitivePalettes + BrandColorSelection.
// - DS does NOT manage selection state.

library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;

import '../foundations/app_colors.dart';
import '../tokens/color_palette.dart';

@immutable
class PalettePreset {
  /// Unique ID used by apps (and Slot mapping).
  final String id;

  /// Human-readable name for UI/debug.
  final String displayName;

  /// Primitive palettes (neutral + chromatic scales).
  final PrimitivePalettes palettes;

  /// Brand/accent selection (primary/secondary/etc).
  final BrandColorSelection brand;

  /// Small preview swatch (UI).
  final Color previewColor;

  /// Optional documentation.
  final String? description;

  const PalettePreset({
    required this.id,
    required this.displayName,
    required this.palettes,
    required this.brand,
    required this.previewColor,
    this.description,
  });
}
