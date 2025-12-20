// core/design_system/src/theme/presets/semi_dark_preset.dart
//
// Less-dark neutral preset.

library;

import 'package:flutter/material.dart';

import '../../foundations/app_colors.dart';
import '../../tokens/color_palette.dart';
import '../palette_preset.dart';

@immutable
class SemiDarkPreset {
  const SemiDarkPreset._();

  static const PalettePreset preset = PalettePreset(
    id: 'semiDark',
    displayName: 'Semi Dark',
    palettes: PrimitivePalettes.semiDark,
    brand: BrandColorSelection.base,
    previewColor: Color(0xFF111827),
    description: 'Softer dark background than full Dark.',
  );
}
