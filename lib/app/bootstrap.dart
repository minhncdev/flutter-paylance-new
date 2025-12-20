// app/bootstrap.dart
//
// App bootstrap (UI initialization only).
// - Builds DS token-driven themes.
// - Creates routing shell.
// - Runs the app.
// - No business logic, no feature wiring, no platform services.

library;

import 'package:flutter/material.dart';

import '../core/design_system/design_system.dart';
import 'app.dart';
import 'routing/app_router.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Build DS themes (token-driven, Material 3).
  // NOTE: These APIs assume your DS theme layer exposes ThemeData builders.
  // If your DS uses a different builder signature, adjust here only (app glue).
  final ThemeData light = AppTheme.light();
  final ThemeData dark = AppTheme.dark();

  final router = AppRouter(lightTheme: light, darkTheme: dark);

  runApp(
    App(
      router: router,
      lightTheme: light,
      darkTheme: dark,
      themeMode: ThemeMode.system,
      supportedLocales: const <Locale>[Locale('en'), Locale('vi')],
    ),
  );
}
