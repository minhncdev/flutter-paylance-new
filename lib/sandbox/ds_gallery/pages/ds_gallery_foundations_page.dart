// sandbox/ds_gallery/pages/ds_gallery_foundations_page.dart
//
// Foundations preview: colors, typography, spacing, shape/elevation.

library;

import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../widgets/ds_gallery_section.dart';

@immutable
class DsGalleryFoundationsPage extends StatelessWidget {
  const DsGalleryFoundationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final colors = <MapEntry<String, Color>>[
      MapEntry('primary', scheme.primary),
      MapEntry('onPrimary', scheme.onPrimary),
      MapEntry('primaryContainer', scheme.primaryContainer),
      MapEntry('secondary', scheme.secondary),
      MapEntry('tertiary', scheme.tertiary),
      MapEntry('error', scheme.error),
      MapEntry('surface', scheme.surface),
      MapEntry('surfaceContainerHighest', scheme.surfaceContainerHighest),
      MapEntry('outline', scheme.outline),
    ];

    final typeSamples = <MapEntry<String, TextStyle?>>[
      MapEntry('displayLarge', text.displayLarge),
      MapEntry('headlineLarge', text.headlineLarge),
      MapEntry('titleLarge', text.titleLarge),
      MapEntry('titleMedium', text.titleMedium),
      MapEntry('bodyLarge', text.bodyLarge),
      MapEntry('bodyMedium', text.bodyMedium),
      MapEntry('labelLarge', text.labelLarge),
    ];

    return ListView(
      padding: context.dsSpacing.all(s.pagePadding),
      children: <Widget>[
        DsGallerySection(
          title: 'Color scheme',
          description: 'Key ColorScheme entries under the current theme.',
          child: Wrap(
            spacing: s.sm,
            runSpacing: s.sm,
            children: <Widget>[
              for (final e in colors) _ColorSwatch(name: e.key, color: e.value),
            ],
          ),
        ),
        SizedBox(height: s.xl),
        DsGallerySection(
          title: 'Typography',
          description: 'TextTheme samples.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final e in typeSamples) ...[
                Text(e.key, style: context.text.labelLarge),
                SizedBox(height: s.xs),
                Text(
                  'The quick brown fox jumps over the lazy dog',
                  style: e.value,
                ),
                SizedBox(height: s.md),
              ],
            ],
          ),
        ),
        SizedBox(height: s.xl),
        DsGallerySection(
          title: 'Spacing tokens',
          description: 'Common spacing values from DS spacing extension.',
          child: Column(
            children: <Widget>[
              _SpacingRow(label: 'xxs', value: s.xxs),
              _SpacingRow(label: 'xs', value: s.xs),
              _SpacingRow(label: 'sm', value: s.sm),
              _SpacingRow(label: 'md', value: s.md),
              _SpacingRow(label: 'lg', value: s.lg),
              _SpacingRow(label: 'xl', value: s.xl),
              _SpacingRow(label: 'pagePadding', value: s.pagePadding),
            ],
          ),
        ),
      ],
    );
  }
}

@immutable
class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorSwatch({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(s.sm),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          SizedBox(height: s.xs),
          Text(name, style: context.text.labelLarge),
        ],
      ),
    );
  }
}

@immutable
class _SpacingRow extends StatelessWidget {
  final String label;
  final double value;

  const _SpacingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: context.dsSpacing.only(bottom: s.sm),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(label, style: context.text.labelLarge),
          ),
          Expanded(
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          SizedBox(width: s.sm),
          Text(value.toStringAsFixed(0), style: context.text.bodyMedium),
        ],
      ),
    );
  }
}
