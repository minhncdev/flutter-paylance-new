// sandbox/ds_gallery/pages/ds_gallery_components_page.dart
//
// Components preview: buttons, cards, inputs, chips/toggles, data display.

library;

import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../widgets/ds_gallery_section.dart';

@immutable
class DsGalleryComponentsPage extends StatefulWidget {
  const DsGalleryComponentsPage({super.key});

  @override
  State<DsGalleryComponentsPage> createState() =>
      _DsGalleryComponentsPageState();
}

class _DsGalleryComponentsPageState extends State<DsGalleryComponentsPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();

  String? _dropdownValue;
  bool _inputsEnabled = true;
  bool _showInputErrors = false;

  bool _switchValue = true;
  bool _checkboxValue = false;
  int _radioValue = 1;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, AppFeedbackTone tone) {
    AppSnackBar.show(
      context,
      AppSnackBarData(
        message: 'This is a ${tone.name} snackbar',
        tone: tone,
        icon: Icons.info_outline,
        actionLabel: 'OK',
        onAction: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return ListView(
      padding: context.dsSpacing.all(s.pagePadding),
      children: <Widget>[
        DsGallerySection(
          title: 'Buttons',
          description: 'Variants + loading/disabled + icon button.',
          child: _ButtonsDemo(onShowSnackBar: _showSnackBar),
        ),
        SizedBox(height: s.xl),
        const DsGallerySection(
          title: 'Cards',
          description: 'Elevated / outlined / filled.',
          child: _CardsDemo(),
        ),
        SizedBox(height: s.xl),
        DsGallerySection(
          title: 'Inputs',
          description: 'Text field, dropdown, date picker (UI-only state).',
          child: _InputsDemo(
            nameCtrl: _nameCtrl,
            dateCtrl: _dateCtrl,
            enabled: _inputsEnabled,
            showErrors: _showInputErrors,
            dropdownValue: _dropdownValue,
            onEnabledChanged: (v) => setState(() => _inputsEnabled = v),
            onShowErrorsChanged: (v) => setState(() => _showInputErrors = v),
            onDropdownChanged: (v) => setState(() => _dropdownValue = v),
          ),
        ),
        SizedBox(height: s.xl),
        const DsGallerySection(
          title: 'Data display',
          description: 'Chips/tags, list tiles, avatars.',
          child: _DataDisplayDemo(),
        ),
        SizedBox(height: s.xl),
        DsGallerySection(
          title: 'Toggles (Material + themed)',
          description:
              'These help validate your ThemeData component theming (Switch/Checkbox/Radio).',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SwitchListTile(
                value: _switchValue,
                onChanged: (v) => setState(() => _switchValue = v),
                title: const Text('Switch'),
              ),
              CheckboxListTile(
                value: _checkboxValue,
                onChanged: (v) => setState(() => _checkboxValue = v ?? false),
                title: const Text('Checkbox'),
              ),
              for (final v in <int>[1, 2, 3])
                RadioListTile<int>(
                  value: v,
                  groupValue: _radioValue,
                  onChanged: (x) => setState(() => _radioValue = x ?? 1),
                  title: Text('Radio $v'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

@immutable
class _ButtonsDemo extends StatelessWidget {
  final void Function(BuildContext, AppFeedbackTone) onShowSnackBar;

  const _ButtonsDemo({required this.onShowSnackBar});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: s.sm,
          runSpacing: s.sm,
          children: <Widget>[
            AppButton(
              label: 'Primary',
              variant: AppButtonVariant.primary,
              onPressed: () {},
            ),
            AppButton(
              label: 'Secondary',
              variant: AppButtonVariant.secondary,
              onPressed: () {},
            ),
            AppButton(
              label: 'Tonal',
              variant: AppButtonVariant.tonal,
              onPressed: () {},
            ),
            AppButton(
              label: 'Outline',
              variant: AppButtonVariant.outline,
              onPressed: () {},
            ),
            AppButton(
              label: 'Ghost',
              variant: AppButtonVariant.ghost,
              onPressed: () {},
            ),
            AppButton(
              label: 'Danger',
              variant: AppButtonVariant.danger,
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: s.md),
        Wrap(
          spacing: s.sm,
          runSpacing: s.sm,
          children: <Widget>[
            AppButton(
              label: 'Loading',
              variant: AppButtonVariant.primary,
              state: const AppButtonState(loading: true),
              onPressed: () {},
            ),
            AppButton(
              label: 'Disabled',
              variant: AppButtonVariant.outline,
              state: const AppButtonState(enabled: false),
              onPressed: () {},
            ),
            AppIconButton(
              icon: Icons.settings_outlined,
              semanticsLabel: 'Settings',
              variant: AppButtonVariant.ghost,
              onPressed: () {},
            ),
            AppButton(
              label: 'Show Snack',
              variant: AppButtonVariant.secondary,
              onPressed: () => onShowSnackBar(context, AppFeedbackTone.info),
            ),
          ],
        ),
      ],
    );
  }
}

@immutable
class _CardsDemo extends StatelessWidget {
  const _CardsDemo();

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return Column(
      children: <Widget>[
        AppCard(
          variant: AppCardVariant.elevated,
          header: Row(
            children: <Widget>[
              Text('Elevated', style: context.text.titleMedium),
              const Spacer(),
              const AppTag(label: 'New', tone: AppTagTone.info),
            ],
          ),
          child: Text(
            'Card content uses DS padding + theme typography.',
            style: context.text.bodyMedium,
          ),
          footer: Text('Footer area', style: context.text.bodySmall),
        ),
        SizedBox(height: s.md),
        AppCard(
          variant: AppCardVariant.outlined,
          header: Text('Outlined', style: context.text.titleMedium),
          child: Text(
            'Outlined variant uses ColorScheme.outline.',
            style: context.text.bodyMedium,
          ),
        ),
        SizedBox(height: s.md),
        AppCard(
          variant: AppCardVariant.filled,
          header: Text('Filled', style: context.text.titleMedium),
          child: Text(
            'Filled uses surfaceContainerHighest.',
            style: context.text.bodyMedium,
          ),
        ),
      ],
    );
  }
}

@immutable
class _InputsDemo extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController dateCtrl;

  final bool enabled;
  final bool showErrors;

  final String? dropdownValue;

  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onShowErrorsChanged;
  final ValueChanged<String?> onDropdownChanged;

  const _InputsDemo({
    required this.nameCtrl,
    required this.dateCtrl,
    required this.enabled,
    required this.showErrors,
    required this.dropdownValue,
    required this.onEnabledChanged,
    required this.onShowErrorsChanged,
    required this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    final nameError = showErrors && nameCtrl.text.trim().isEmpty
        ? 'Required'
        : null;
    final ddError = showErrors && dropdownValue == null ? 'Select one' : null;
    final dateError = showErrors && dateCtrl.text.trim().isEmpty
        ? 'Pick a date'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: AppChip(
                label: enabled ? 'Enabled' : 'Disabled',
                selected: enabled,
                onSelected: (_) => onEnabledChanged(!enabled),
              ),
            ),
            SizedBox(width: s.sm),
            Expanded(
              child: AppChip(
                label: showErrors ? 'Errors: ON' : 'Errors: OFF',
                selected: showErrors,
                onSelected: (_) => onShowErrorsChanged(!showErrors),
              ),
            ),
          ],
        ),
        SizedBox(height: s.lg),
        AppTextField(
          controller: nameCtrl,
          enabled: enabled,
          labelText: 'Name',
          hintText: 'Enter name',
          errorText: nameError,
          onChanged: (_) {},
        ),
        SizedBox(height: s.md),
        AppDropdown<String>(
          enabled: enabled,
          labelText: 'Category',
          hintText: 'Choose',
          errorText: ddError,
          value: dropdownValue,
          onChanged: onDropdownChanged,
          items: const <AppDropdownItem<String>>[
            AppDropdownItem(value: 'a', label: 'Option A'),
            AppDropdownItem(value: 'b', label: 'Option B'),
            AppDropdownItem(value: 'c', label: 'Option C'),
          ],
        ),
        SizedBox(height: s.md),
        AppDatePicker(
          controller: dateCtrl,
          enabled: enabled,
          labelText: 'Date',
          hintText: 'Select date',
          errorText: dateError,
          value: dateCtrl.text.isEmpty ? null : DateTime.now(),
          firstDate: DateTime(2000, 1, 1),
          lastDate: DateTime.now().add(const Duration(days: 3650)),
          onChanged: (_) {},
        ),
      ],
    );
  }
}

@immutable
class _DataDisplayDemo extends StatelessWidget {
  const _DataDisplayDemo();

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: s.sm,
          runSpacing: s.sm,
          children: const <Widget>[
            AppChip(label: 'Filter', selected: true, onSelected: null),
            AppChip(label: 'Income', selected: false, onSelected: null),
            AppTag(label: 'Success', tone: AppTagTone.success),
            AppTag(label: 'Warning', tone: AppTagTone.warning),
          ],
        ),
        SizedBox(height: s.lg),
        AppListTile(
          useContainer: true,
          leading: const AppAvatar(size: AppAvatarSize.sm, initials: 'AL'),
          title: const Text('Alice Lee'),
          subtitle: const Text('Transfer received'),
          trailing: const AppTag(label: 'Completed', tone: AppTagTone.success),
          onTap: () {},
        ),
        SizedBox(height: s.sm),
        AppListTile(
          useContainer: true,
          leading: const AppAvatar(
            size: AppAvatarSize.sm,
            icon: Icons.storefront_outlined,
          ),
          title: const Text('Merchant payment'),
          subtitle: const Text('Coffee shop'),
          trailing: const AppTag(label: 'Pending', tone: AppTagTone.warning),
          onTap: () {},
        ),
      ],
    );
  }
}
