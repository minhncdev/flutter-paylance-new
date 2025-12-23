// sandbox/ds_gallery/pages/ds_gallery_settings_page.dart
//
// Settings page: theme selection + preset + brand (system mode only).

library;

import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../app/config/brand_defaults.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../app/theme/theme_controller_scope.dart';
import '../../../app/theme/theme_selection_config.dart';
import '../widgets/ds_gallery_section.dart';

@immutable
class DsGallerySettingsPage extends StatelessWidget {
  const DsGallerySettingsPage({super.key});

  ThemeController? _maybeController(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ThemeControllerScope>();
    return scope?.notifier;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final controller = _maybeController(context);

    if (controller == null) {
      return ListView(
        padding: context.dsSpacing.all(s.pagePadding),
        children: const <Widget>[
          AppEmptyState(
            title: 'ThemeControllerScope not found',
            description:
                'DsGallery cannot control app theme.\nEnsure App.builder wraps child with ThemeControllerScope.',
            illustration: Icon(Icons.error_outline),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final state = controller.state;
        final config = state.config;

        final ThemeSelectionType selectionType = switch (config) {
          SystemBasedThemeConfig _ => ThemeSelectionType.systemBased,
          PresetBasedThemeConfig _ => ThemeSelectionType.presetBased,
          _ => ThemeSelectionType.systemBased,
        };

        final ThemeMode currentMode = config is SystemBasedThemeConfig
            ? config.mode
            : state.themeMode;

        final String? selectedPresetId = config is PresetBasedThemeConfig
            ? config.presetId
            : null;
        final String? selectedBrandId = config is SystemBasedThemeConfig
            ? config.brandId
            : null;

        final presets = ThemePaletteRegistry.instance.getAll()
          ..sort((a, b) => a.displayName.compareTo(b.displayName));

        final lightPresets = presets
            .where((p) => p.toneBrightness == Brightness.light)
            .toList();
        final darkPresets = presets
            .where((p) => p.toneBrightness == Brightness.dark)
            .toList();

        return ListView(
          padding: context.dsSpacing.all(s.pagePadding),
          children: <Widget>[
            DsGallerySection(
              title: 'Theme selection',
              description:
                  'Choose between system light/dark or a fixed-tone preset.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SegmentedButton<ThemeSelectionType>(
                    segments: const <ButtonSegment<ThemeSelectionType>>[
                      ButtonSegment(
                        value: ThemeSelectionType.systemBased,
                        label: Text('System'),
                      ),
                      ButtonSegment(
                        value: ThemeSelectionType.presetBased,
                        label: Text('Presets'),
                      ),
                    ],
                    selected: <ThemeSelectionType>{selectionType},
                    onSelectionChanged: (set) {
                      controller.setSelectionType(set.first);
                    },
                  ),
                  SizedBox(height: s.md),
                  if (selectionType == ThemeSelectionType.systemBased) ...[
                    Text('Mode', style: context.text.titleMedium),
                    SizedBox(height: s.xs),
                    SegmentedButton<ThemeMode>(
                      segments: const <ButtonSegment<ThemeMode>>[
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('System'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                        ),
                      ],
                      selected: <ThemeMode>{currentMode},
                      onSelectionChanged: (set) =>
                          controller.setThemeMode(set.first),
                    ),
                  ] else ...[
                    Text(
                      'Preset tone is fixed (light OR dark).',
                      style: context.text.bodyMedium,
                    ),
                    SizedBox(height: s.xs),
                    Text(
                      'When selecting a preset, the app theme switches immediately.',
                      style: context.text.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: s.xl),

            if (selectionType == ThemeSelectionType.systemBased) ...[
              DsGallerySection(
                title: 'Brand color (system mode only)',
                description:
                    'Brand is changeable only when using system light/dark.',
                child: _BrandPickerSection(
                  selectedBrandId: selectedBrandId,
                  onSelect: (id) => controller.setBrandColor(id),
                ),
              ),
            ] else ...[
              DsGallerySection(
                title: 'Presets (Light tone)',
                description: 'These presets force Brightness.light.',
                child: _PresetPickerSection(
                  presets: lightPresets,
                  selectedPresetId: selectedPresetId,
                  onSelect: (id) {
                    if (id != null) controller.setPalettePreset(id);
                  },
                ),
              ),
              SizedBox(height: s.xl),
              DsGallerySection(
                title: 'Presets (Dark tone)',
                description: 'These presets force Brightness.dark.',
                child: _PresetPickerSection(
                  presets: darkPresets,
                  selectedPresetId: selectedPresetId,
                  onSelect: (id) {
                    if (id != null) controller.setPalettePreset(id);
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PresetPickerSection extends StatelessWidget {
  final List<PalettePreset> presets;
  final String? selectedPresetId;
  final ValueChanged<String?> onSelect;

  const _PresetPickerSection({
    required this.presets,
    required this.selectedPresetId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    if (presets.isEmpty) {
      return Text('No presets', style: context.text.bodyMedium);
    }

    return Wrap(
      spacing: s.sm,
      runSpacing: s.sm,
      children: <Widget>[
        for (final p in presets)
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _SplitColorDot(
                  left: p.preview.background,
                  right: p.preview.primary,
                  borderColor: Theme.of(context).colorScheme.outlineVariant,
                  size: 12,
                ),
                SizedBox(width: s.xs),
                Text(p.displayName),
              ],
            ),
            selected: selectedPresetId == p.id,
            onSelected: (_) => onSelect(p.id),
          ),
      ],
    );
  }
}

class _BrandPickerSection extends StatelessWidget {
  final String? selectedBrandId;
  final ValueChanged<String> onSelect;

  const _BrandPickerSection({
    required this.selectedBrandId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final options = BrandDefaults.options;

    return Wrap(
      spacing: s.sm,
      runSpacing: s.sm,
      children: <Widget>[
        for (final o in options)
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: o.previewColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: s.xs),
                Text(o.displayName),
              ],
            ),
            selected: selectedBrandId == o.id,
            onSelected: (_) => onSelect(o.id),
          ),
      ],
    );
  }
}

@immutable
class _SplitColorDot extends StatelessWidget {
  final Color left;
  final Color right;
  final Color borderColor;
  final double size;

  const _SplitColorDot({
    required this.left,
    required this.right,
    required this.borderColor,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          Expanded(child: ColoredBox(color: left)),
          Expanded(child: ColoredBox(color: right)),
        ],
      ),
    );
  }
}
