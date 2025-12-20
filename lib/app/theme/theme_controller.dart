// app/theme/theme_controller.dart
//
// App-shell theme controller (no feature logic).
// - Owns ThemeSelectionConfig
// - Rebuilds only what changed (light/dark) using ThemeResolver + cache
// - Designed so "default tone" can be changed by app config (ThemeDefaults).

library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import 'theme_resolver.dart';
import 'theme_selection_config.dart';
import 'theme_state.dart';

class ThemeController extends ChangeNotifier {
  final ThemeResolver _resolver;

  ThemeState _state;

  ThemeController({ThemeResolver? resolver})
    : _resolver = resolver ?? ThemeResolver(),
      _state = ThemeState(
        config: const SystemBasedThemeConfig(),
        lightTheme: ThemeData(),
        darkTheme: ThemeData(),
        themeMode: ThemeMode.system,
      ) {
    _rebuildAll(); // initialize themes
  }

  ThemeState get state => _state;

  // ---------- Public API ----------

  void setSelectionType(ThemeSelectionType type) {
    final ThemeSelectionConfig next = switch (type) {
      ThemeSelectionType.systemBased => const SystemBasedThemeConfig(),
      ThemeSelectionType.brandBased => const BrandBasedThemeConfig(
        brandPresetId: 'white',
      ),
    };

    _state = ThemeState(
      config: next,
      lightTheme: _resolver.buildTheme(next, Brightness.light),
      darkTheme: _resolver.buildTheme(next, Brightness.dark),
      themeMode: _themeModeFromConfig(next),
    );
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    final cfg = _state.config;
    if (cfg is! SystemBasedThemeConfig) return;

    final updated = cfg.copyWith(mode: mode);
    _state = ThemeState(
      config: updated,
      lightTheme: _state.lightTheme,
      darkTheme: _state.darkTheme,
      themeMode: updated.mode,
    );
    notifyListeners();
  }

  /// SystemBased: override light preset (null = use Slot mapping default)
  void setLightOverridePreset(String? presetId) {
    final cfg = _state.config;
    if (cfg is! SystemBasedThemeConfig) return;

    final updated = cfg.copyWith(lightOverridePresetId: presetId);
    final newLight = _resolver.buildTheme(updated, Brightness.light);

    _state = ThemeState(
      config: updated,
      lightTheme: newLight,
      darkTheme: _state.darkTheme,
      themeMode: updated.mode,
    );
    notifyListeners();
  }

  /// SystemBased: override dark preset (null = use Slot mapping default)
  void setDarkOverridePreset(String? presetId) {
    final cfg = _state.config;
    if (cfg is! SystemBasedThemeConfig) return;

    final updated = cfg.copyWith(darkOverridePresetId: presetId);
    final newDark = _resolver.buildTheme(updated, Brightness.dark);

    _state = ThemeState(
      config: updated,
      lightTheme: _state.lightTheme,
      darkTheme: newDark,
      themeMode: updated.mode,
    );
    notifyListeners();
  }

  /// BrandBased: select a single presetId for both light/dark (themeMode can still be system)
  void setBrandPreset(String presetId) {
    final cfg = _state.config;
    if (cfg is! BrandBasedThemeConfig) return;

    final updated = cfg.copyWith(brandPresetId: presetId);

    _state = ThemeState(
      config: updated,
      lightTheme: _resolver.buildTheme(updated, Brightness.light),
      darkTheme: _resolver.buildTheme(updated, Brightness.dark),
      themeMode: updated.mode,
    );
    notifyListeners();
  }

  /// Call this after changing defaults mapping (typically on app restart).
  void rebuildFromDefaults() {
    _rebuildAll();
    notifyListeners();
  }

  // ---------- Internal ----------

  void _rebuildAll() {
    final cfg = _state.config;
    _state = ThemeState(
      config: cfg,
      lightTheme: _resolver.buildTheme(cfg, Brightness.light),
      darkTheme: _resolver.buildTheme(cfg, Brightness.dark),
      themeMode: _themeModeFromConfig(cfg),
    );
  }

  ThemeMode _themeModeFromConfig(ThemeSelectionConfig config) {
    return switch (config) {
      SystemBasedThemeConfig c => c.mode,
      BrandBasedThemeConfig c => c.mode,
    };
  }
}
