// core/design_system/src/theme/presets/milk_white_preset.dart
//
// Warm neutral preset: "Milk White".

library;

import 'package:flutter/material.dart';

import '../../foundations/app_colors.dart';
import '../../tokens/color_palette.dart';
import '../palette_preset.dart';

@immutable
class MilkWhitePreset {
  const MilkWhitePreset._();

  static const PalettePreset preset = PalettePreset(
    id: 'milkWhite',
    displayName: 'Trắng sữa',
    palettes: PrimitivePalettes.milkWhite,
    brand: BrandColorSelection.base,
    previewColor: Color(0xFFFFFDF7),
    description: 'Warm neutral surfaces (less cold than pure white).',
  );
}
