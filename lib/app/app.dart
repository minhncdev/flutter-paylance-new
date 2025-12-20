// app/app.dart
//
// App root widget (UI glue).
// - Wires Design System theme + routing shell + localization.
// - No feature imports, no business logic, no state management for features.

library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/design_system/design_system.dart';
import 'routing/app_router.dart';

@immutable
class App extends StatelessWidget {
  final AppRouter router;

  /// DS-driven themes (Material 3).
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  /// App-level theme mode (system by default).
  final ThemeMode themeMode;

  /// Localization wiring (app layer).
  final Iterable<Locale> supportedLocales;
  final Locale? locale;

  const App({
    super.key,
    required this.router,
    required this.lightTheme,
    required this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.supportedLocales = const <Locale>[Locale('en'), Locale('vi')],
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Theme wiring (DS -> ThemeData).
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,

      // Localization wiring (no business logic).
      locale: locale,
      supportedLocales: supportedLocales.toList(growable: false),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Routing shell (Navigator 1.0 style, minimal & robust).
      initialRoute: router.initialRoute,
      onGenerateRoute: router.onGenerateRoute,
      onUnknownRoute: router.onUnknownRoute,

      // Use Material 3 everywhere.
      builder: (context, child) {
        // DS utilities are available via BuildContext extensions if needed.
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
