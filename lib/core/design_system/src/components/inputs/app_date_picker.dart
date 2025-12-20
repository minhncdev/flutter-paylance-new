/// AppDatePicker: DS standardized date picker field.
/// - Renders a read-only text field that opens Material date picker dialog.
/// - No validation logic: feature passes errorText.
/// - Accessible: label/hint/helper/error supported.
/// - Feature manages controller lifecycle (recommended).
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'app_text_field.dart';
import 'input_style_resolver.dart';

typedef AppDateFormatter = String Function(BuildContext context, DateTime date);

@immutable
class AppDatePicker extends StatelessWidget {
  /// External controller is recommended so feature owns lifecycle.
  final TextEditingController controller;

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  final DateTime firstDate;
  final DateTime lastDate;

  final DateTime? initialDate;
  final DatePickerEntryMode initialEntryMode;

  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  final bool enabled;
  final AppInputSize size;

  final AppDateFormatter? formatter;

  /// Optional semantics label override.
  final String? semanticsLabel;

  const AppDatePicker({
    super.key,
    required this.controller,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.size = AppInputSize.md,
    this.formatter,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    // Keep controller text in sync with value (UI presentation only).
    // Feature decides what value means; DS only formats.
    final String? display = _format(context, value);
    if (controller.text != (display ?? '')) {
      controller.text = display ?? '';
    }

    final metrics = context.dsComponents.input;
    final iconSize = metrics.iconSize;

    return AppTextField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      size: size,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      semanticsLabel: semanticsLabel ?? labelText,
      suffixIcon: Icon(Icons.calendar_today_outlined, size: iconSize),
      onTap: enabled ? () => _openPicker(context) : null,
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    // UI-only: open native Material date picker. No routing/business logic.
    final DateTime base = initialDate ?? value ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: base.isBefore(firstDate)
          ? firstDate
          : (base.isAfter(lastDate) ? lastDate : base),
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: initialEntryMode,
    );

    // Feature handles null as "no change"/"cleared" as desired.
    if (picked != null) {
      onChanged(picked);
    }
  }

  String? _format(BuildContext context, DateTime? date) {
    if (date == null) return null;
    if (formatter != null) return formatter!(context, date);
    // Default: locale-aware formatting from MaterialLocalizations.
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }
}
