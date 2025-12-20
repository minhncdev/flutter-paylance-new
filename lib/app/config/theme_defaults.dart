// app/config/theme_defaults.dart
//
// App-owned mapping layer (Slot -> PresetId).
// ✅ Đây là nơi bạn đổi "white" -> "milkWhite" để đổi default tone nhanh nhất.

library;

import '../../core/design_system/design_system.dart';

class ThemeDefaults {
  const ThemeDefaults._();

  /// Slot -> PresetId mapping (SINGLE SOURCE OF TRUTH for defaults).
  static const Map<ToneSlot, String> slotMapping = <ToneSlot, String>{
    ToneSlot.defaultLight: 'dark', // 👈 đổi thành 'milkWhite' là đổi tone Light
    ToneSlot.defaultDark: 'dark', // 👈 đổi thành 'semiDark' nếu muốn
  };

  static const String fallbackLightPresetId = 'white';
  static const String fallbackDarkPresetId = 'dark';

  static String presetIdForSlot(ToneSlot slot) {
    final mapped = slotMapping[slot];
    if (mapped != null) return mapped;

    return slot == ToneSlot.defaultLight
        ? fallbackLightPresetId
        : fallbackDarkPresetId;
  }
}
