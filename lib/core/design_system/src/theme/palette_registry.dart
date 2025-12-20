// core/design_system/src/theme/palette_registry.dart
//
// In-memory registry for PalettePreset definitions.
// - DS provides registry; apps decide what to register and when.
// - Singleton is acceptable here; includes resetForTest() escape hatch.

library;

import 'package:flutter/foundation.dart';

import 'palette_preset.dart';

class ThemePaletteRegistry {
  final Map<String, PalettePreset> _presets = <String, PalettePreset>{};

  ThemePaletteRegistry._();

  static final ThemePaletteRegistry instance = ThemePaletteRegistry._();

  void register(PalettePreset preset) {
    assert(
      !_presets.containsKey(preset.id),
      'PalettePreset "${preset.id}" already registered.',
    );
    _presets[preset.id] = preset;
  }

  PalettePreset? get(String id) => _presets[id];

  List<PalettePreset> getAll() => _presets.values.toList(growable: false);

  bool contains(String id) => _presets.containsKey(id);

  @visibleForTesting
  void resetForTest() => _presets.clear();
}
