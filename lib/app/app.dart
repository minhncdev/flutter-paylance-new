// app/app.dart
//
// App root widget (UI glue).
// - Wires Design System theme + routing shell + localization.
// - Theme is controlled by ThemeController (app shell only).

library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routing/app_router.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_controller_scope.dart';

@immutable
class App extends StatelessWidget {
  final AppRouter router;
  final ThemeController themeController;

  final Iterable<Locale> supportedLocales;
  final Locale? locale;

  const App({
    super.key,
    required this.router,
    required this.themeController,
    this.supportedLocales = const <Locale>[Locale('en'), Locale('vi')],
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        final s = themeController.state;

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: s.lightTheme,
          darkTheme: s.darkTheme,
          themeMode: s.themeMode,

          locale: locale,
          supportedLocales: supportedLocales.toList(growable: false),
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          initialRoute: router.initialRoute,
          onGenerateRoute: router.onGenerateRoute,
          onUnknownRoute: router.onUnknownRoute,

          builder: (context, child) {
            return ThemeControllerScope(
              controller: themeController,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
