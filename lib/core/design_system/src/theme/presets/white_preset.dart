// core/design_system/src/theme/presets/white_preset.dart
//
// Core preset: "White" (neutral base).

library;

import 'package:flutter/material.dart';

import '../../foundations/app_colors.dart';
import '../../tokens/color_palette.dart';
import '../palette_preset.dart';

@immutable
class WhitePreset {
  const WhitePreset._();

  static const PalettePreset preset = PalettePreset(
    id: 'white',
    displayName: 'Trắng',
    palettes: PrimitivePalettes.base,
    brand: BrandColorSelection.base,
    previewColor: Color(0xFFFFFFFF),
    description: 'Neutral base (clean white).',
  );
}
