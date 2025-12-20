// app/theme/theme_controller_scope.dart
//
// InheritedNotifier to access ThemeController anywhere in app shell UI.

library;

import 'package:flutter/widgets.dart';

import 'theme_controller.dart';

class ThemeControllerScope extends InheritedNotifier<ThemeController> {
  const ThemeControllerScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ThemeControllerScope>();
    assert(scope != null, 'ThemeControllerScope not found in widget tree.');
    return scope!.notifier!;
  }
}
