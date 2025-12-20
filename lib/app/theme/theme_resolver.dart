// app/theme/theme_resolver.dart
//
// Resolve ThemeData from:
// - ThemeSelectionConfig (systemBased/brandBased)
// - Slot -> PresetId mapping (ThemeDefaults)
// - Palette registry (ThemePaletteRegistry)
// - Cached ThemeData

library;

import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../config/theme_defaults.dart';
import 'theme_cache.dart';
import 'theme_selection_config.dart';

class ThemeResolver {
  final ThemePaletteRegistry _registry;
  final ThemeCache _cache;

  ThemeResolver({ThemePaletteRegistry? registry, ThemeCache? cache})
    : _registry = registry ?? ThemePaletteRegistry.instance,
      _cache = cache ?? ThemeCache();

  String resolvePresetId(ThemeSelectionConfig config, Brightness brightness) {
    return switch (config) {
      SystemBasedThemeConfig c => () {
        final override = brightness == Brightness.light
            ? c.lightOverridePresetId
            : c.darkOverridePresetId;

        if (override != null) return override;

        final slot = brightness == Brightness.light ? c.lightSlot : c.darkSlot;
        return ThemeDefaults.presetIdForSlot(slot);
      }(),
      BrandBasedThemeConfig c => c.brandPresetId,
    };
  }

  ThemeData buildTheme(ThemeSelectionConfig config, Brightness brightness) {
    final presetId = resolvePresetId(config, brightness);

    return _cache.getOrBuild(
      presetId: presetId,
      brightness: brightness,
      build: () {
        final preset =
            _registry.get(presetId) ??
            _registry.get(
              brightness == Brightness.light
                  ? ThemeDefaults.fallbackLightPresetId
                  : ThemeDefaults.fallbackDarkPresetId,
            );

        assert(preset != null, 'No fallback preset registered in registry.');
        return AppThemeBuilder.buildForPreset(
          preset: preset!,
          brightness: brightness,
        );
      },
    );
  }

  void invalidateCache({String? presetId}) =>
      _cache.invalidate(presetId: presetId);
}
