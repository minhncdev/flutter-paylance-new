/// DS Chip primitive (selectable/filter chip).
/// - Wraps Material 3 FilterChip with standardized API.
/// - Theme-driven colors/typography; DS spacing/radii for padding.
/// - Stateless: selection state controlled by caller.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

enum AppChipVariant { filter, input }

@immutable
class AppChip extends StatelessWidget {
  final String label;

  /// Controlled selection state.
  final bool selected;

  /// Whether chip is enabled.
  final bool enabled;

  /// Callback for selection changes (app/feature layer controls state).
  final ValueChanged<bool>? onSelected;

  final IconData? leadingIcon;

  /// If provided, shows a delete affordance. Callback is app-controlled.
  final VoidCallback? onDeleted;

  final AppChipVariant variant;

  final String? semanticsLabel;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.enabled = true,
    this.onSelected,
    this.leadingIcon,
    this.onDeleted,
    this.variant = AppChipVariant.filter,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final t = Theme.of(context).textTheme;

    final iconSize = s.md;

    final Widget? avatar = leadingIcon != null
        ? Icon(leadingIcon, size: iconSize)
        : null;

    final TextStyle? labelStyle = t.labelLarge;

    final EdgeInsets padding = context.dsSpacing.symmetric(
      horizontal: s.sm,
      vertical: s.xxs,
    );

    final Widget chip = switch (variant) {
      AppChipVariant.filter => FilterChip(
        label: Text(label, style: labelStyle),
        selected: selected,
        onSelected: enabled ? onSelected : null,
        avatar: avatar,
        padding: padding,
        showCheckmark: true,
      ),
      AppChipVariant.input => InputChip(
        label: Text(label, style: labelStyle),
        selected: selected,
        onSelected: enabled ? onSelected : null,
        avatar: avatar,
        padding: padding,
        onDeleted: enabled ? onDeleted : null,
      ),
    };

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticsLabel ?? label,
      child: chip,
    );
  }
}
