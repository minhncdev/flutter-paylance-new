// core/design_system/src/theme/presets/dark_preset.dart
//
// Darker neutral preset.

library;

import 'package:flutter/material.dart';

import '../../foundations/app_colors.dart';
import '../../tokens/color_palette.dart';
import '../palette_preset.dart';

@immutable
class DarkPreset {
  const DarkPreset._();

  static const PalettePreset preset = PalettePreset(
    id: 'dark',
    displayName: 'Dark',
    palettes: PrimitivePalettes.dark,
    brand: BrandColorSelection.base,
    previewColor: Color(0xFF0B1220),
    description: 'Darker neutral for dark mode.',
  );
}
