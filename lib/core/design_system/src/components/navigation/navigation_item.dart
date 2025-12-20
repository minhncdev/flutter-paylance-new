/// Neutral navigation item contract for DS navigation primitives.
/// - Contains display data only (no route info, no routing logic).
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class AppNavigationItem {
  /// Stable identifier for app-layer mapping (route wiring happens outside DS).
  final String id;

  final String label;

  /// Default (unselected) icon.
  final IconData icon;

  /// Optional selected icon. If null, [icon] is reused.
  final IconData? selectedIcon;

  /// Whether the item is interactable.
  final bool enabled;

  /// Optional badge count. If null => no badge.
  /// If 0 => can still show a dot badge based on [showBadgeWhenZero].
  final int? badgeCount;

  /// If true, badge shows even when [badgeCount] == 0 (dot badge).
  final bool showBadgeWhenZero;

  /// Optional custom badge widget override (e.g., DS AppBadge from another folder).
  /// If provided, it will be used instead of [badgeCount]-based badge.
  final Widget? badge;

  /// Optional semantics label override.
  final String? semanticsLabel;

  const AppNavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.enabled = true,
    this.badgeCount,
    this.showBadgeWhenZero = false,
    this.badge,
    this.semanticsLabel,
  });

  AppNavigationItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    IconData? selectedIcon,
    bool? enabled,
    int? badgeCount,
    bool? showBadgeWhenZero,
    Widget? badge,
    String? semanticsLabel,
  }) {
    return AppNavigationItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      enabled: enabled ?? this.enabled,
      badgeCount: badgeCount ?? this.badgeCount,
      showBadgeWhenZero: showBadgeWhenZero ?? this.showBadgeWhenZero,
      badge: badge ?? this.badge,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
    );
  }

  bool get hasBadge {
    if (badge != null) return true;
    if (badgeCount == null) return false;
    if (badgeCount! > 0) return true;
    return showBadgeWhenZero;
  }

  IconData iconForSelected(bool selected) =>
      selected ? (selectedIcon ?? icon) : icon;
}
