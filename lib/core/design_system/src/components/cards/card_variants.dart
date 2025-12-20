/// Card contracts for DS.
/// - Defines variants and padding presets (no UI widgets).
library;

import 'package:flutter/foundation.dart';

/// Visual variants aligned to common Material 3 surface patterns.
enum AppCardVariant {
  /// Elevated surface with shadow.
  elevated,

  /// Outlined surface with border.
  outlined,

  /// Filled surface (container background), typically no shadow.
  filled,

  /// Plain surface (no border, no shadow), usually matches `colorScheme.surface`.
  surface,
}

/// Padding presets for card content.
/// Values are resolved from DS component tokens via resolver.
enum AppCardPadding { sm, md, lg }

@immutable
class AppCardConfig {
  final AppCardVariant variant;
  final AppCardPadding padding;

  const AppCardConfig({
    this.variant = AppCardVariant.surface,
    this.padding = AppCardPadding.md,
  });

  AppCardConfig copyWith({AppCardVariant? variant, AppCardPadding? padding}) {
    return AppCardConfig(
      variant: variant ?? this.variant,
      padding: padding ?? this.padding,
    );
  }
}
