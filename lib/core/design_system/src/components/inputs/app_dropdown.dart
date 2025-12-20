/// AppDropdown: DS standardized Material 3 dropdown field.
/// - Token/theme-driven via AppInputStyleResolver + DS ThemeExtensions.
/// - No validation logic: feature passes errorText.
/// - Accessible: label/hint/helper/error supported.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';
import 'input_style_resolver.dart';

@immutable
class AppDropdownItem<T> {
  final T value;
  final String label;
  final bool enabled;
  final Widget? leading;

  const AppDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
    this.leading,
  });
}

@immutable
class AppDropdown<T> extends StatelessWidget {
  final List<AppDropdownItem<T>> items;
  final T? value;

  final ValueChanged<T?>? onChanged;

  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  final bool enabled;
  final AppInputSize size;

  final Widget? prefixIcon;
  final bool isDense;

  /// If true, expands to full width.
  final bool isExpanded;

  final String? semanticsLabel;

  const AppDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.size = AppInputSize.md,
    this.prefixIcon,
    this.isDense = false,
    this.isExpanded = true,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = AppInputStyleResolver.resolve(
      context,
      size: size,
      enabled: enabled,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: null, // Dropdown provides its own affordance icon.
      isDense: isDense,
    );

    final textStyle = AppInputStyleResolver.textStyleFor(context, size: size);
    final s = context.dsSpacing.spacing;

    return Semantics(
      enabled: enabled,
      label: semanticsLabel ?? labelText,
      child: ConstrainedBox(
        constraints: resolved.constraints,
        child: DropdownButtonFormField<T>(
          value: value,
          isExpanded: isExpanded,
          decoration: resolved.decoration,
          style: textStyle,
          onChanged: enabled ? onChanged : null,
          icon: Icon(Icons.arrow_drop_down, size: resolved.iconSize),
          items: items
              .map((it) {
                return DropdownMenuItem<T>(
                  value: it.value,
                  enabled: it.enabled,
                  child: Row(
                    children: [
                      if (it.leading != null) it.leading!,
                      if (it.leading != null) SizedBox(width: s.sm),
                      Flexible(
                        child: Text(
                          it.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }
}
