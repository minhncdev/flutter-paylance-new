// sandbox/ds_gallery/pages/ds_gallery_navigation_page.dart
//
// Navigation preview: bottom bars + drawer preview.

library;

import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../widgets/ds_gallery_section.dart';

@immutable
class DsGalleryNavigationPage extends StatefulWidget {
  const DsGalleryNavigationPage({super.key});

  @override
  State<DsGalleryNavigationPage> createState() =>
      _DsGalleryNavigationPageState();
}

class _DsGalleryNavigationPageState extends State<DsGalleryNavigationPage> {
  int _selectedIndex = 0;
  bool _useCenterAction = true;

  List<AppNavigationItem> get _items => const <AppNavigationItem>[
    AppNavigationItem(
      id: 'home',
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    AppNavigationItem(
      id: 'pay',
      label: 'Pay',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      badgeCount: 3,
    ),
    AppNavigationItem(
      id: 'profile',
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
    AppNavigationItem(
      id: 'more',
      label: 'More',
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view,
    ),
  ];

  Future<void> _showDrawerPreview(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        final s = context.dsSpacing.spacing;
        return SafeArea(
          child: SizedBox(
            height: 420,
            child: AppDrawer(
              header: Padding(
                padding: context.dsSpacing.all(s.pagePadding),
                child: Text('Drawer Preview', style: context.text.titleLarge),
              ),
              items: _items,
              selectedId: _items[_selectedIndex].id,
              onSelected: (it) => Navigator.of(context).pop(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return ListView(
      padding: context.dsSpacing.all(s.pagePadding),
      children: <Widget>[
        DsGallerySection(
          title: 'Bottom bars',
          description: 'Preview both variants.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: s.sm,
                runSpacing: s.sm,
                children: <Widget>[
                  AppButton(
                    label: _useCenterAction
                        ? 'Center action: ON'
                        : 'Center action: OFF',
                    variant: AppButtonVariant.secondary,
                    onPressed: () =>
                        setState(() => _useCenterAction = !_useCenterAction),
                  ),
                ],
              ),
              SizedBox(height: s.md),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(s.md),
                ),
                clipBehavior: Clip.antiAlias,
                child: _useCenterAction
                    ? AppBottomBarCenterAction(
                        items: _items,
                        selectedIndex: _selectedIndex,
                        onSelected: (i) => setState(() => _selectedIndex = i),
                        centerActionSemanticsLabel: 'Add',
                        centerAction: FloatingActionButton(
                          onPressed: () {},
                          child: const Icon(Icons.add),
                        ),
                      )
                    : AppBottomBar(
                        items: _items,
                        selectedIndex: _selectedIndex,
                        onSelected: (i) => setState(() => _selectedIndex = i),
                      ),
              ),
            ],
          ),
        ),
        SizedBox(height: s.xl),
        DsGallerySection(
          title: 'Drawer',
          description: 'Open a preview drawer in a bottom sheet.',
          child: AppButton(
            label: 'Open drawer preview',
            variant: AppButtonVariant.primary,
            onPressed: () => _showDrawerPreview(context),
          ),
        ),
        SizedBox(height: s.xl),
        const DsGallerySection(
          title: 'List tiles',
          description: 'Common navigation rows.',
          child: _ListTilePreview(),
        ),
      ],
    );
  }
}

@immutable
class _ListTilePreview extends StatelessWidget {
  const _ListTilePreview();

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return Column(
      children: <Widget>[
        AppListTile(
          useContainer: true,
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          subtitle: const Text('Example subtitle'),
          onTap: () {},
        ),
        SizedBox(height: s.sm),
        AppListTile(
          useContainer: true,
          leading: const Icon(Icons.security_outlined),
          title: const Text('Security'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }
}
