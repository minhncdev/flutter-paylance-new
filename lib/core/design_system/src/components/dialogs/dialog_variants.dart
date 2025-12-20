/// Dialog contracts (variants + config) for DS.
/// - No show/hide orchestration.
/// - App layer decides when/how to present.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AppDialogTone { neutral, info, success, warning, danger }

enum AppAlertDialogVariant {
  /// Standard alert dialog with title/content/actions.
  standard,

  /// Confirmation dialog (emphasizes primary action).
  confirmation,

  /// Destructive dialog (danger tone, emphasizes destructive action).
  destructive,
}

enum AppBottomSheetVariant {
  /// Standard sheet with optional drag handle + header/body/footer.
  standard,

  /// Action sheet: list of actions, usually compact.
  action,
}

@immutable
class AppDialogAction {
  /// Button widget provided by app layer (recommended: DS AppButton).
  final Widget child;

  /// Optional semantics label for screen readers.
  final String? semanticsLabel;

  const AppDialogAction({required this.child, this.semanticsLabel});
}

@immutable
class AppAlertDialogConfig {
  final AppAlertDialogVariant variant;

  /// Optional tone to affect icon / accent usage.
  final AppDialogTone tone;

  /// Whether actions are stacked vertically (better for small screens).
  final bool actionsStacked;

  /// Optional semantics label override for the dialog container.
  final String? semanticsLabel;

  const AppAlertDialogConfig({
    this.variant = AppAlertDialogVariant.standard,
    this.tone = AppDialogTone.neutral,
    this.actionsStacked = false,
    this.semanticsLabel,
  });

  AppAlertDialogConfig copyWith({
    AppAlertDialogVariant? variant,
    AppDialogTone? tone,
    bool? actionsStacked,
    String? semanticsLabel,
  }) {
    return AppAlertDialogConfig(
      variant: variant ?? this.variant,
      tone: tone ?? this.tone,
      actionsStacked: actionsStacked ?? this.actionsStacked,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
    );
  }
}

@immutable
class AppBottomSheetConfig {
  final AppBottomSheetVariant variant;

  /// Whether to show a drag handle at the top.
  final bool showDragHandle;

  /// Optional semantics label override for the sheet container.
  final String? semanticsLabel;

  const AppBottomSheetConfig({
    this.variant = AppBottomSheetVariant.standard,
    this.showDragHandle = true,
    this.semanticsLabel,
  });

  AppBottomSheetConfig copyWith({
    AppBottomSheetVariant? variant,
    bool? showDragHandle,
    String? semanticsLabel,
  }) {
    return AppBottomSheetConfig(
      variant: variant ?? this.variant,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
    );
  }
}
