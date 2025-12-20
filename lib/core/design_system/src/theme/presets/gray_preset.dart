// core/design_system/src/theme/presets/gray_preset.dart
//
// Cool gray neutral preset.

library;

import 'package:flutter/material.dart';

import '../../foundations/app_colors.dart';
import '../../tokens/color_palette.dart';
import '../palette_preset.dart';

@immutable
class GrayPreset {
  const GrayPreset._();

  static const PalettePreset preset = PalettePreset(
    id: 'gray',
    displayName: 'Gray',
    palettes: PrimitivePalettes.gray,
    brand: BrandColorSelection.base,
    previewColor: Color(0xFF6F7888),
    description: 'Cooler neutral palette.',
  );
}
