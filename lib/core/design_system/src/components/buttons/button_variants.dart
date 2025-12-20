/// Button enums and simple state models.
/// - No UI widgets here; only contracts used by DS button components.
library;

import 'package:flutter/foundation.dart';

/// Visual variants aligned with Material 3 button families.
enum AppButtonVariant {
  /// Filled (high emphasis).
  primary,

  /// Filled tonal (medium emphasis).
  secondary,

  /// Tonal/neutral (medium emphasis, often for surfaces).
  tonal,

  /// Outlined (low emphasis).
  outline,

  /// Text/ghost (lowest emphasis, no container by default).
  ghost,

  /// Destructive action (filled, error emphasis).
  danger,
}

/// Button sizes (layout metrics are resolved from DS component tokens).
enum AppButtonSize { sm, md, lg }

/// State flags for a button.
/// - `enabled=false` disables interaction (even if onPressed exists).
/// - `loading=true` disables interaction and shows progress indicator.
@immutable
class AppButtonState {
  final bool enabled;
  final bool loading;

  const AppButtonState({this.enabled = true, this.loading = false});

  AppButtonState copyWith({bool? enabled, bool? loading}) {
    return AppButtonState(
      enabled: enabled ?? this.enabled,
      loading: loading ?? this.loading,
    );
  }
}
