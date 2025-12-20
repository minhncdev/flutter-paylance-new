// sandbox/ds_gallery/ds_gallery_routes.dart
//
// DS Gallery routes (sandbox only).
// - No routing logic beyond route table definition.
// - Host app can plug these into MaterialApp.routes or onGenerateRoute.

library;

import 'package:flutter/material.dart';

import 'ds_gallery_page.dart';

@immutable
class DsGalleryRoutes {
  const DsGalleryRoutes._();

  /// Root route for Design System Gallery.
  static const String root = '/ds-gallery';

  /// Simple routes map for apps using MaterialApp(routes: ...).
  /// - Optionally pass DS light/dark themes so the gallery can toggle them locally.
  static Map<String, WidgetBuilder> routes({
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return <String, WidgetBuilder>{
      root: (_) => DsGalleryPage(lightTheme: lightTheme, darkTheme: darkTheme),
    };
  }

  /// Optional onGenerateRoute helper.
  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings, {
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    if (settings.name == root) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) =>
            DsGalleryPage(lightTheme: lightTheme, darkTheme: darkTheme),
      );
    }
    return null;
  }
}
