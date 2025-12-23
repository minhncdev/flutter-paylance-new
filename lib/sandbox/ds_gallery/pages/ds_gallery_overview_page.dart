// sandbox/ds_gallery/pages/ds_gallery_overview_page.dart
//
// Overview page: quick entry points to the gallery sections.

library;

import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../widgets/ds_gallery_section.dart';

typedef DsGalleryNavigate = void Function(String id);

@immutable
class DsGalleryOverviewPage extends StatelessWidget {
  final DsGalleryNavigate onNavigate;

  const DsGalleryOverviewPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return ListView(
      padding: context.dsSpacing.all(s.pagePadding),
      children: <Widget>[
        DsGallerySection(
          title: 'Quick actions',
          description: 'Jump to key preview areas.',
          child: Wrap(
            spacing: s.sm,
            runSpacing: s.sm,
            children: <Widget>[
              AppButton(
                label: 'Foundations',
                variant: AppButtonVariant.secondary,
                onPressed: () => onNavigate('foundations'),
              ),
              AppButton(
                label: 'Components',
                variant: AppButtonVariant.secondary,
                onPressed: () => onNavigate('components'),
              ),
              AppButton(
                label: 'Navigation',
                variant: AppButtonVariant.secondary,
                onPressed: () => onNavigate('navigation'),
              ),
              AppButton(
                label: 'Feedback',
                variant: AppButtonVariant.secondary,
                onPressed: () => onNavigate('feedback'),
              ),
              AppButton(
                label: 'Settings',
                variant: AppButtonVariant.primary,
                onPressed: () => onNavigate('settings'),
              ),
            ],
          ),
        ),
        SizedBox(height: s.xl),
        DsGallerySection(
          title: 'What to verify here',
          description:
              'Use this gallery to validate tokens, component states, and interactions under each theme/preset.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '• Colors/typography/shape/elevation tokens',
                style: context.text.bodyMedium,
              ),
              SizedBox(height: s.xs),
              Text(
                '• Buttons, cards, inputs, chips/toggles',
                style: context.text.bodyMedium,
              ),
              SizedBox(height: s.xs),
              Text(
                '• Snackbars, toasts, dialogs, bottom sheets',
                style: context.text.bodyMedium,
              ),
              SizedBox(height: s.xs),
              Text('• Bottom bars + drawers', style: context.text.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
