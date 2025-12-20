// app/bootstrap.dart
//
// App bootstrap (UI initialization only).
// - Registers DS palette presets.
// - Creates ThemeController (app shell).
// - Runs the app.

library;

import 'package:flutter/material.dart';

import '../core/design_system/design_system.dart';
import 'app.dart';
import 'routing/app_router.dart';
import 'theme/theme_controller.dart';

void _registerPalettePresets() {
  final r = ThemePaletteRegistry.instance;

  r.register(WhitePreset.preset);
  r.register(MilkWhitePreset.preset);
  r.register(DarkPreset.preset);
  r.register(SemiDarkPreset.preset);
  r.register(GrayPreset.preset);

  // Optional brand presets:
  // r.register(GreenBrandPreset.preset);
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  _registerPalettePresets();

  final themeController = ThemeController();
  final router = const AppRouter();

  runApp(
    App(
      router: router,
      themeController: themeController,
      supportedLocales: const <Locale>[Locale('en'), Locale('vi')],
    ),
  );
}
