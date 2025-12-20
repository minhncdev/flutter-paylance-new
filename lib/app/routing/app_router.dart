// app/routing/app_router.dart
//
// Routing shell (UI-only).
// - Provides routes for app shell + DS gallery.
// - No feature routing here; features can plug in later via an extension point.
// - No business logic.

library;

import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../../sandbox/ds_gallery/ds_gallery_page.dart';

@immutable
class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String dsGallery = '/ds-gallery';
}

@immutable
class AppRouter {
  const AppRouter();

  String get initialRoute => AppRoutes.home;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const _AppShellHomePage(),
        );

      case AppRoutes.dsGallery:
        return MaterialPageRoute<void>(
          settings: settings,
          // Use ambient Theme from host app (do not pass explicit ThemeData).
          builder: (_) => const DsGalleryPage(),
        );

      default:
        return onUnknownRoute(settings);
    }
  }

  Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => _UnknownRoutePage(routeName: settings.name),
    );
  }
}

@immutable
class _AppShellHomePage extends StatelessWidget {
  const _AppShellHomePage();

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return AppScaffold(
      appBar: const AppAppBar(title: 'App Shell'),
      body: ListView(
        padding: context.dsSpacing.symmetric(
          horizontal: s.pagePadding,
          vertical: s.lg,
        ),
        children: <Widget>[
          AppCard(
            variant: AppCardVariant.elevated,
            header: Text(
              'Design System',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            child: Text(
              'This is the app shell. Features plug in later. '
              'Use the DS Gallery to validate light/dark + components.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            footer: AppButton(
              label: 'Open DS Gallery',
              fullWidth: true,
              variant: AppButtonVariant.primary,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.dsGallery),
            ),
          ),
          SizedBox(height: s.lg),
          AppCard(
            variant: AppCardVariant.outlined,
            header: Text(
              'Localization',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            child: Text(
              'Material localization delegates are wired in App. '
              'Add app-specific delegates later without touching DS.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        items: const <AppNavigationItem>[
          AppNavigationItem(
            id: 'home',
            label: 'Home',
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
          ),
          AppNavigationItem(
            id: 'ds',
            label: 'Gallery',
            icon: Icons.grid_view_outlined,
            selectedIcon: Icons.grid_view,
          ),
        ],
        selectedIndex: 0,
        onSelected: (index) {
          // UI-only: just navigate to DS gallery as a placeholder.
          if (index == 1) Navigator.of(context).pushNamed(AppRoutes.dsGallery);
        },
      ),
    );
  }
}

@immutable
class _UnknownRoutePage extends StatelessWidget {
  final String? routeName;

  const _UnknownRoutePage({this.routeName});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return AppScaffold(
      appBar: const AppAppBar(title: 'Not Found'),
      body: Padding(
        padding: context.dsSpacing.all(s.pagePadding),
        child: AppEmptyState(
          centered: true,
          illustration: const Icon(Icons.help_outline),
          title: 'Route not found',
          description: routeName == null
              ? 'Unknown route.'
              : 'No page registered for: $routeName',
          primaryAction: AppButton(
            label: 'Back',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
    );
  }
}
