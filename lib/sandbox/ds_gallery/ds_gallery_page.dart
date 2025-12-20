// sandbox/ds_gallery/ds_gallery_page.dart
//
// DS Gallery page (sandbox only).
// - Showcases Design System components under the current Theme.
// - No business logic; only demo UI states.
// - Can locally toggle light/dark if host provides lightTheme/darkTheme.

library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';

@immutable
class DsGalleryPage extends StatefulWidget {
  /// Optional themes for local light/dark switching.
  /// If null, the gallery uses the ambient Theme from the host app.
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  /// Optional initial theme mode used only when [lightTheme] & [darkTheme] are provided.
  final ThemeMode initialThemeMode;

  const DsGalleryPage({
    super.key,
    this.lightTheme,
    this.darkTheme,
    this.initialThemeMode = ThemeMode.system,
  });

  @override
  State<DsGalleryPage> createState() => _DsGalleryPageState();
}

class _DsGalleryPageState extends State<DsGalleryPage> {
  late ThemeMode _mode = widget.initialThemeMode;

  // Inputs demo state (UI-only).
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();

  String? _dropdownValue;

  bool _inputsEnabled = true;
  bool _showInputErrors = false;

  // Toast overlay demo (UI-only).
  OverlayEntry? _toastEntry;
  Timer? _toastTimer;

  int _bottomBarIndex = 0;

  @override
  void dispose() {
    _toastTimer?.cancel();
    _toastEntry?.remove();
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canToggleTheme =
        widget.lightTheme != null && widget.darkTheme != null;

    final ThemeData? forcedTheme = switch (_mode) {
      ThemeMode.light => widget.lightTheme,
      ThemeMode.dark => widget.darkTheme,
      ThemeMode.system => null,
    };

    final Widget page = _buildPage(context, canToggleTheme: canToggleTheme);

    // If host provides DS themes, allow local switching in sandbox via AnimatedTheme.
    if (forcedTheme != null) {
      return AnimatedTheme(
        data: forcedTheme,
        duration: MotionDurations.medium,
        curve: Cubic(
          EasingTokens.standard.x1,
          EasingTokens.standard.y1,
          EasingTokens.standard.x2,
          EasingTokens.standard.y2,
        ),
        child: page,
      );
    }

    return page;
  }

  Widget _buildPage(BuildContext context, {required bool canToggleTheme}) {
    final s = context.dsSpacing.spacing;

    final navItems = <AppNavigationItem>[
      const AppNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
      ),
      const AppNavigationItem(
        id: 'pay',
        label: 'Pay',
        icon: Icons.credit_card_outlined,
        selectedIcon: Icons.credit_card,
        badgeCount: 3,
      ),
      const AppNavigationItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
      ),
    ];

    return AppScaffold(
      appBar: AppAppBar(
        title: 'DS Gallery',
        actions: <Widget>[
          if (canToggleTheme)
            _ThemeModeToggle(
              mode: _mode,
              onChanged: (m) => setState(() => _mode = m),
            ),
        ],
      ),
      drawer: AppDrawer(
        header: Text('Design System', style: context.text.titleLarge),
        items: navItems,
        selectedId: navItems[_bottomBarIndex].id,
        onSelected: (item) {
          final idx = navItems.indexWhere((e) => e.id == item.id);
          if (idx >= 0) {
            Navigator.of(context).pop();
            setState(() => _bottomBarIndex = idx);
          }
        },
      ),
      bottomNavigationBar: AppBottomBar(
        items: navItems,
        selectedIndex: _bottomBarIndex,
        onSelected: (i) => setState(() => _bottomBarIndex = i),
      ),
      body: ListView(
        padding: context.dsSpacing.symmetric(
          horizontal: s.pagePadding,
          vertical: s.lg,
        ),
        children: <Widget>[
          Section(
            title: 'Buttons',
            subtitle: 'Variants, sizes, states (enabled/loading)',
            child: _ButtonsDemo(onShowSnackBar: _showSnackBar),
          ),
          const AppDivider(),

          Section(
            title: 'Cards',
            subtitle: 'Variants + header/footer + DS padding',
            child: _CardsDemo(),
          ),
          const AppDivider(),

          Section(
            title: 'Inputs',
            subtitle: 'Material 3 inputs with DS standardized API',
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
          const AppDivider(),

          Section(
            title: 'Data Display',
            subtitle: 'ListTile, Chip, Tag, Divider, Avatar',
            child: _DataDisplayDemo(),
          ),
          const AppDivider(),

          Section(
            title: 'Dialogs',
            subtitle: 'Alert dialog + bottom sheet (app layer orchestration)',
            child: _DialogsDemo(
              onShowAlert: _showAlertDialog,
              onShowSheet: _showBottomSheet,
            ),
          ),
          const AppDivider(),

          Section(
            title: 'Feedback',
            subtitle: 'SnackBar + Toast + Loading + EmptyState',
            child: _FeedbackDemo(
              onShowSnackBar: _showSnackBar,
              onShowToast: _showToast,
            ),
          ),
          SizedBox(height: s.xl),
        ],
      ),
    );
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

  Future<void> _showAlertDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return AppAlertDialog(
          config: const AppAlertDialogConfig(
            variant: AppAlertDialogVariant.confirmation,
            tone: AppDialogTone.info,
            actionsStacked: false,
          ),
          title: 'Confirm action',
          message:
              'This dialog UI is provided by DS. App controls showing & closing.',
          actions: <AppDialogAction>[
            AppDialogAction(
              semanticsLabel: 'Cancel',
              child: AppButton(
                label: 'Cancel',
                variant: AppButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            AppDialogAction(
              semanticsLabel: 'Continue',
              child: AppButton(
                label: 'Continue',
                variant: AppButtonVariant.primary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // DS sheet renders its own surface.
      builder: (_) {
        return AppBottomSheet(
          config: const AppBottomSheetConfig(
            variant: AppBottomSheetVariant.standard,
            showDragHandle: true,
          ),
          title: 'Bottom sheet',
          subtitle: 'DS provides UI; app controls presentation.',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppListTile(
                title: const Text('Action A'),
                leading: const Icon(Icons.bolt_outlined),
                onTap: () => Navigator.of(context).pop(),
                useContainer: true,
              ),
              SizedBox(height: context.dsSpacing.spacing.sm),
              AppListTile(
                title: const Text('Action B'),
                leading: const Icon(Icons.shield_outlined),
                onTap: () => Navigator.of(context).pop(),
                useContainer: true,
              ),
            ],
          ),
          footer: AppButton(
            label: 'Close',
            fullWidth: true,
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }

  void _showToast(BuildContext context, AppToastTone tone) {
    _toastTimer?.cancel();
    _toastEntry?.remove();

    final s = context.dsSpacing.spacing;

    _toastEntry = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: s.pagePadding,
          right: s.pagePadding,
          bottom: s.xl,
          child: AppToast(
            title: 'Toast',
            message: 'Tone: ${tone.name}. App controls overlay lifecycle.',
            tone: tone,
            visible: true,
            onClose: () {
              _toastTimer?.cancel();
              _toastEntry?.remove();
              _toastEntry = null;
            },
          ),
        );
      },
    );

    Overlay.of(context).insert(_toastEntry!);
    _toastTimer = Timer(const Duration(seconds: 3), () {
      _toastEntry?.remove();
      _toastEntry = null;
    });
  }
}

@immutable
class _ThemeModeToggle extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return Padding(
      padding: context.dsSpacing.only(right: s.sm),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ThemeMode>(
          value: mode,
          onChanged: (m) {
            if (m != null) onChanged(m);
          },
          items: const <DropdownMenuItem<ThemeMode>>[
            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          ],
        ),
      ),
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

@immutable
class _DialogsDemo extends StatelessWidget {
  final Future<void> Function(BuildContext) onShowAlert;
  final Future<void> Function(BuildContext) onShowSheet;

  const _DialogsDemo({required this.onShowAlert, required this.onShowSheet});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return Wrap(
      spacing: s.sm,
      runSpacing: s.sm,
      children: <Widget>[
        AppButton(
          label: 'Show Alert Dialog',
          variant: AppButtonVariant.primary,
          onPressed: () => onShowAlert(context),
        ),
        AppButton(
          label: 'Show Bottom Sheet',
          variant: AppButtonVariant.secondary,
          onPressed: () => onShowSheet(context),
        ),
      ],
    );
  }
}

@immutable
class _FeedbackDemo extends StatelessWidget {
  final void Function(BuildContext, AppFeedbackTone) onShowSnackBar;
  final void Function(BuildContext, AppToastTone) onShowToast;

  const _FeedbackDemo({
    required this.onShowSnackBar,
    required this.onShowToast,
  });

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
              label: 'Snack: Success',
              variant: AppButtonVariant.secondary,
              onPressed: () => onShowSnackBar(context, AppFeedbackTone.success),
            ),
            AppButton(
              label: 'Snack: Danger',
              variant: AppButtonVariant.outline,
              onPressed: () => onShowSnackBar(context, AppFeedbackTone.danger),
            ),
            AppButton(
              label: 'Toast: Info',
              variant: AppButtonVariant.tonal,
              onPressed: () => onShowToast(context, AppToastTone.info),
            ),
          ],
        ),
        SizedBox(height: s.lg),
        const AppLoading(centered: false, label: 'Inline loading'),
        SizedBox(height: s.lg),
        AppEmptyState(
          title: 'Empty state',
          description: 'This is an example empty state for content absence.',
          illustration: const Icon(Icons.inbox_outlined),
          primaryAction: AppButton(
            label: 'Primary action',
            variant: AppButtonVariant.primary,
            onPressed: () {},
          ),
          secondaryAction: AppButton(
            label: 'Secondary action',
            variant: AppButtonVariant.ghost,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
