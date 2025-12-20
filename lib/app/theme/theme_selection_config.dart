// app/theme/theme_selection_config.dart
//
// Type-safe theme selection config for app shell.
// - Persist slots (defaultLight/defaultDark), not concrete preset IDs.
// - Optional overrides allow user choice.

library;

import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';

sealed class ThemeSelectionConfig {
  const ThemeSelectionConfig();

  ThemeSelectionType get type;

  Map<String, Object?> toJson();

  static ThemeSelectionConfig fromJson(Map<String, Object?> json) {
    final type = json['type'];
    if (type == 'systemBased') {
      return SystemBasedThemeConfig.fromJson(json);
    }
    if (type == 'brandBased') {
      return BrandBasedThemeConfig.fromJson(json);
    }
    // Fallback safe default
    return const SystemBasedThemeConfig();
  }
}

final class SystemBasedThemeConfig extends ThemeSelectionConfig {
  final ThemeMode mode;

  final ToneSlot lightSlot;
  final String? lightOverridePresetId;

  final ToneSlot darkSlot;
  final String? darkOverridePresetId;

  const SystemBasedThemeConfig({
    this.mode = ThemeMode.system,
    this.lightSlot = ToneSlot.defaultLight,
    this.lightOverridePresetId,
    this.darkSlot = ToneSlot.defaultDark,
    this.darkOverridePresetId,
  });

  @override
  ThemeSelectionType get type => ThemeSelectionType.systemBased;

  SystemBasedThemeConfig copyWith({
    ThemeMode? mode,
    ToneSlot? lightSlot,
    String? lightOverridePresetId,
    ToneSlot? darkSlot,
    String? darkOverridePresetId,
  }) {
    return SystemBasedThemeConfig(
      mode: mode ?? this.mode,
      lightSlot: lightSlot ?? this.lightSlot,
      lightOverridePresetId: lightOverridePresetId,
      darkSlot: darkSlot ?? this.darkSlot,
      darkOverridePresetId: darkOverridePresetId,
    );
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'type': 'systemBased',
    'mode': mode.name,
    'lightSlot': lightSlot.name,
    'lightOverridePresetId': lightOverridePresetId,
    'darkSlot': darkSlot.name,
    'darkOverridePresetId': darkOverridePresetId,
  };

  static SystemBasedThemeConfig fromJson(Map<String, Object?> json) {
    ThemeMode readMode(String? v) => ThemeMode.values
        .where((e) => e.name == v)
        .cast<ThemeMode?>()
        .firstWhere((e) => e != null, orElse: () => ThemeMode.system)!;

    ToneSlot readSlot(String? v, ToneSlot fallback) => ToneSlot.values
        .where((e) => e.name == v)
        .cast<ToneSlot?>()
        .firstWhere((e) => e != null, orElse: () => fallback)!;

    return SystemBasedThemeConfig(
      mode: readMode(json['mode'] as String?),
      lightSlot: readSlot(json['lightSlot'] as String?, ToneSlot.defaultLight),
      lightOverridePresetId: json['lightOverridePresetId'] as String?,
      darkSlot: readSlot(json['darkSlot'] as String?, ToneSlot.defaultDark),
      darkOverridePresetId: json['darkOverridePresetId'] as String?,
    );
  }
}

final class BrandBasedThemeConfig extends ThemeSelectionConfig {
  final String brandPresetId;
  final ThemeMode mode;

  const BrandBasedThemeConfig({
    required this.brandPresetId,
    this.mode = ThemeMode.system,
  });

  @override
  ThemeSelectionType get type => ThemeSelectionType.brandBased;

  BrandBasedThemeConfig copyWith({String? brandPresetId, ThemeMode? mode}) {
    return BrandBasedThemeConfig(
      brandPresetId: brandPresetId ?? this.brandPresetId,
      mode: mode ?? this.mode,
    );
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'type': 'brandBased',
    'brandPresetId': brandPresetId,
    'mode': mode.name,
  };

  static BrandBasedThemeConfig fromJson(Map<String, Object?> json) {
    final id = (json['brandPresetId'] as String?) ?? 'white';
    final modeStr = json['mode'] as String?;
    final mode = ThemeMode.values.firstWhere(
      (e) => e.name == modeStr,
      orElse: () => ThemeMode.system,
    );
    return BrandBasedThemeConfig(brandPresetId: id, mode: mode);
  }
}
