// core/design_system/src/theme/theme_selection_types.dart
//
// Theme selection primitives shared by apps.
// - ToneSlot is intentionally stable: apps should persist slots, not preset IDs.

library;

enum ThemeSelectionType { systemBased, brandBased }

/// Stable slots used by apps to map to a concrete PalettePreset ID.
/// Persist slots (defaultLight/defaultDark) so changing app defaults is trivial.
enum ToneSlot { defaultLight, defaultDark }
