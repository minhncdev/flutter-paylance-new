// core/design_system/src/theme/presets/green_brand_preset.dart
//
// Brand-based preset with green primary.

library;

import 'package:flutter/material.dart';

import '../../foundations/app_colors.dart';
import '../../tokens/color_palette.dart';
import '../palette_preset.dart';

@immutable
class GreenBrandPreset {
  const GreenBrandPreset._();

  static const PalettePreset preset = PalettePreset(
    id: 'green',
    displayName: 'Xanh',
    palettes: PrimitivePalettes.base,
    brand: BrandColorSelection.green,
    previewColor: Color(0xFF16A34A),
  );
}
