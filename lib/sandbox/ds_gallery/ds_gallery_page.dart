// sandbox/ds_gallery/ds_gallery_page.dart
//
// DS Gallery entry page (sandbox only).
// - Provides navigation between preview pages.
// - Can locally toggle light/dark if host provides lightTheme/darkTheme.
// - No business logic; only demo UI states.

library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../../app/theme/theme_controller.dart';
import '../../app/theme/theme_controller_scope.dart';
import '../../app/theme/theme_selection_config.dart';
import '../../app/config/brand_defaults.dart';

typedef DsGalleryNavigate = void Function(String id);

@immutable
class _GalleryTab {
  final String title;
  final AppNavigationItem item;
  const _GalleryTab({required this.title, required this.item});
}

const List<_GalleryTab> _kGalleryTabs = <_GalleryTab>[
  _GalleryTab(
    title: 'Overview',
    item: AppNavigationItem(
      id: 'overview',
      label: 'Overview',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
  ),
  _GalleryTab(
    title: 'Foundations',
    item: AppNavigationItem(
      id: 'foundations',
      label: 'Foundations',
      icon: Icons.layers_outlined,
      selectedIcon: Icons.layers,
    ),
  ),
  _GalleryTab(
    title: 'Components',
    item: AppNavigationItem(
      id: 'components',
      label: 'Components',
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
    ),
  ),
  _GalleryTab(
    title: 'Feedback',
    item: AppNavigationItem(
      id: 'feedback',
      label: 'Feedback',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
    ),
  ),
  _GalleryTab(
    title: 'Settings',
    item: AppNavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.tune_outlined,
      selectedIcon: Icons.tune,
    ),
  ),
];

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
  int _tabIndex = 0;

  // Inputs demo state (UI-only).
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();

  String? _dropdownValue;
  bool _inputsEnabled = true;
  bool _showInputErrors = false;

  // Toast overlay demo (UI-only).
  OverlayEntry? _toastEntry;
  Timer? _toastTimer;

  // Navigation preview demo state (UI-only).
  int _navPreviewIndex = 0;
  bool _navPreviewUseCenterAction = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    _toastTimer?.cancel();
    _toastEntry?.remove();
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
    final tabs = _kGalleryTabs;
    final currentTab = tabs[_tabIndex];

    return AppScaffold(
      appBar: AppAppBar(
        title: currentTab.title,
        actions: <Widget>[
          if (canToggleTheme)
            _ThemeModeToggle(
              mode: _mode,
              onChanged: (m) => setState(() => _mode = m),
            ),
          AppIconButton(
            icon: Icons.tune_outlined,
            semanticsLabel: 'Open settings',
            variant: AppButtonVariant.ghost,
            onPressed: () => setState(() => _tabIndex = 4),
          ),
        ],
      ),
      bodyBehavior: AppScaffoldBodyBehavior.plain,
      bottomNavigationBar: AppBottomBar(
        items: tabs.map((e) => e.item).toList(growable: false),
        selectedIndex: _tabIndex,
        onSelected: (i) => setState(() => _tabIndex = i),
      ),
      body: AnimatedSwitcher(
        duration: MotionDurations.medium,
        child: KeyedSubtree(
          key: ValueKey<int>(_tabIndex),
          child: _buildTabBody(context, _tabIndex),
        ),
      ),
    );
  }

  EdgeInsets _pagePadding(BuildContext context) {
    final s = context.dsSpacing.spacing;
    return context.dsSpacing.symmetric(
      horizontal: s.pagePadding,
      vertical: s.lg,
    );
  }

  Widget _buildTabBody(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _buildOverviewTab(context);
      case 1:
        return _buildFoundationsTab(context);
      case 2:
        return _buildComponentsTab(context);
      case 3:
        return _buildFeedbackTab(context);
      case 4:
        return _buildSettingsTab(context);
      default:
        return _buildOverviewTab(context);
    }
  }

  Widget _buildOverviewTab(BuildContext context) {
    final s = context.dsSpacing.spacing;
    return ListView(
      padding: _pagePadding(context),
      children: <Widget>[
        AppCard(
          variant: AppCardVariant.elevated,
          header: Text('Design System Gallery', style: context.text.titleLarge),
          child: Text(
            'Preview DS foundations + components under the current theme. '
            'Use Settings to switch System vs Preset + Brand (system only).',
            style: context.text.bodyMedium,
          ),
          footer: Wrap(
            spacing: s.sm,
            runSpacing: s.sm,
            children: <Widget>[
              AppButton(
                label: 'Foundations',
                variant: AppButtonVariant.secondary,
                onPressed: () => setState(() => _tabIndex = 1),
              ),
              AppButton(
                label: 'Components',
                variant: AppButtonVariant.secondary,
                onPressed: () => setState(() => _tabIndex = 2),
              ),
              AppButton(
                label: 'Feedback',
                variant: AppButtonVariant.secondary,
                onPressed: () => setState(() => _tabIndex = 3),
              ),
              AppButton(
                label: 'Settings',
                variant: AppButtonVariant.primary,
                onPressed: () => setState(() => _tabIndex = 4),
              ),
            ],
          ),
        ),
        SizedBox(height: s.lg),
        AppCard(
          variant: AppCardVariant.outlined,
          header: Text('Quick checks', style: context.text.titleMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                '• Verify contrast in Light/Dark',
                style: context.text.bodyMedium,
              ),
              SizedBox(height: s.xs),
              Text(
                '• Verify preset tone is fixed (no split light/dark)',
                style: context.text.bodyMedium,
              ),
              SizedBox(height: s.xs),
              Text(
                '• Verify brand only changes in System mode',
                style: context.text.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoundationsTab(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return ListView(
      padding: _pagePadding(context),
      children: <Widget>[
        AppCard(
          variant: AppCardVariant.outlined,
          header: Text('Colors', style: context.text.titleMedium),
          child: Wrap(
            spacing: s.sm,
            runSpacing: s.sm,
            children: <Widget>[
              _ColorSwatch(
                label: 'Primary',
                bg: scheme.primary,
                fg: scheme.onPrimary,
              ),
              _ColorSwatch(
                label: 'Secondary',
                bg: scheme.secondary,
                fg: scheme.onSecondary,
              ),
              _ColorSwatch(
                label: 'Tertiary',
                bg: scheme.tertiary,
                fg: scheme.onTertiary,
              ),
              _ColorSwatch(
                label: 'Surface',
                bg: scheme.surface,
                fg: scheme.onSurface,
              ),
              _ColorSwatch(
                label: 'Background',
                bg: scheme.background,
                fg: scheme.onBackground,
              ),
              _ColorSwatch(
                label: 'Error',
                bg: scheme.error,
                fg: scheme.onError,
              ),
            ],
          ),
        ),
        SizedBox(height: s.lg),
        AppCard(
          variant: AppCardVariant.outlined,
          header: Text('Typography', style: context.text.titleMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Title Large', style: t.titleLarge),
              SizedBox(height: s.xs),
              Text('Title Medium', style: t.titleMedium),
              SizedBox(height: s.xs),
              Text('Body Medium', style: t.bodyMedium),
              SizedBox(height: s.xs),
              Text('Body Small', style: t.bodySmall),
              SizedBox(height: s.xs),
              Text('Label Large', style: t.labelLarge),
            ],
          ),
        ),
        SizedBox(height: s.lg),
        AppCard(
          variant: AppCardVariant.outlined,
          header: Text('Spacing tokens', style: context.text.titleMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _KeyValueRow(label: 'pagePadding', value: '${s.pagePadding}'),
              _KeyValueRow(label: 'sectionGap', value: '${s.sectionGap}'),
              _KeyValueRow(label: 'itemGap', value: '${s.itemGap}'),
              _KeyValueRow(
                label: 'xs / sm / md',
                value: '${s.xs} / ${s.sm} / ${s.md}',
              ),
              _KeyValueRow(label: 'lg / xl', value: '${s.lg} / ${s.xl}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComponentsTab(BuildContext context) {
    final s = context.dsSpacing.spacing;

    final previewItems = <AppNavigationItem>[
      const AppNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
      ),
      const AppNavigationItem(
        id: 'pay',
        label: 'Pay',
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        badgeCount: 3,
      ),
      const AppNavigationItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
      ),
      const AppNavigationItem(
        id: 'more',
        label: 'More',
        icon: Icons.grid_view_outlined,
        selectedIcon: Icons.grid_view,
      ),
    ];

    return ListView(
      padding: _pagePadding(context),
      children: <Widget>[
        AppCard(
          variant: AppCardVariant.elevated,
          header: Text('Buttons', style: context.text.titleMedium),
          child: _ButtonsDemo(onShowSnackBar: _showSnackBar),
        ),
        SizedBox(height: s.lg),
        const AppCard(
          variant: AppCardVariant.elevated,
          header: Text('Cards'),
          child: _CardsDemo(),
        ),
        SizedBox(height: s.lg),
        AppCard(
          variant: AppCardVariant.elevated,
          header: Text('Inputs', style: context.text.titleMedium),
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
        SizedBox(height: s.lg),
        const AppCard(
          variant: AppCardVariant.elevated,
          header: Text('Data display'),
          child: _DataDisplayDemo(),
        ),
        SizedBox(height: s.lg),
        AppCard(
          variant: AppCardVariant.elevated,
          header: Text('Navigation', style: context.text.titleMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Wrap(
                spacing: s.sm,
                runSpacing: s.sm,
                children: <Widget>[
                  AppChip(
                    label: 'Bottom bar',
                    selected: !_navPreviewUseCenterAction,
                    onSelected: (_) =>
                        setState(() => _navPreviewUseCenterAction = false),
                  ),
                  AppChip(
                    label: 'Center action',
                    selected: _navPreviewUseCenterAction,
                    onSelected: (_) =>
                        setState(() => _navPreviewUseCenterAction = true),
                  ),
                ],
              ),
              SizedBox(height: s.md),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: context.dsRadii.md,
                ),
                child: _navPreviewUseCenterAction
                    ? AppBottomBarCenterAction(
                        items: previewItems,
                        selectedIndex: _navPreviewIndex,
                        onSelected: (i) => setState(() => _navPreviewIndex = i),
                        centerActionSemanticsLabel: 'Primary action',
                        centerAction: FloatingActionButton(
                          onPressed: () =>
                              _showSnackBar(context, AppFeedbackTone.info),
                          child: const Icon(Icons.add),
                        ),
                      )
                    : AppBottomBar(
                        items: previewItems,
                        selectedIndex: _navPreviewIndex,
                        onSelected: (i) => setState(() => _navPreviewIndex = i),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackTab(BuildContext context) {
    final s = context.dsSpacing.spacing;
    return ListView(
      padding: _pagePadding(context),
      children: <Widget>[
        AppCard(
          variant: AppCardVariant.elevated,
          header: Text(
            'Snackbars / Toasts / States',
            style: context.text.titleMedium,
          ),
          child: _FeedbackDemo(
            onShowSnackBar: _showSnackBar,
            onShowToast: _showToast,
          ),
        ),
        SizedBox(height: s.lg),
        AppCard(
          variant: AppCardVariant.elevated,
          header: Text('Dialogs & Sheets', style: context.text.titleMedium),
          child: _DialogsDemo(
            onShowAlert: _showAlertDialog,
            onShowSheet: _showBottomSheet,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab(BuildContext context) {
    return ListView(
      padding: _pagePadding(context),
      children: const <Widget>[DsGalleryThemeControls()],
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

@immutable
class DsGalleryThemeControls extends StatelessWidget {
  const DsGalleryThemeControls({super.key});

  ThemeController? _maybeController(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ThemeControllerScope>();
    return scope?.notifier;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _maybeController(context);
    final s = context.dsSpacing.spacing;

    if (controller == null) {
      return AppCard(
        variant: AppCardVariant.outlined,
        header: Text('Theme Controls', style: context.text.titleMedium),
        child: Text(
          'ThemeControllerScope not found.\n'
          'DsGallery cannot control app theme.\n'
          'Ensure App.builder wraps child with ThemeControllerScope.',
          style: context.text.bodyMedium,
        ),
      );
    }

    final presets = ThemePaletteRegistry.instance.getAll()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    if (presets.isEmpty) {
      return AppCard(
        variant: AppCardVariant.outlined,
        header: Text('Theme Controls', style: context.text.titleMedium),
        child: Text(
          'No palette presets registered.\n'
          'Did you register presets in bootstrap()?',
          style: context.text.bodyMedium,
        ),
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

        return AppCard(
          variant: AppCardVariant.elevated,
          header: Text('Theme Controls', style: context.text.titleMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: s.xs),

              // Selection type: System vs Presets
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
                    ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
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

              if (selectionType == ThemeSelectionType.systemBased) ...[
                SizedBox(height: s.lg),
                _BrandPickerSection(
                  title: 'Brand color (System mode only)',
                  selectedBrandId: selectedBrandId,
                  onSelect: (id) => controller.setBrandColor(id),
                ),
                SizedBox(height: s.xs),
                Text(
                  'Default palette (light/dark) is controlled by ThemeDefaults.',
                  style: context.text.bodySmall,
                ),
              ] else ...[
                SizedBox(height: s.lg),
                _PresetPickerSection(
                  title: 'Presets (Light tone)',
                  presets: presets
                      .where((p) => p.toneBrightness == Brightness.light)
                      .toList(),
                  selectedPresetId: selectedPresetId,
                  onSelect: (id) {
                    if (id != null) controller.setPalettePreset(id);
                  },
                ),
                SizedBox(height: s.lg),
                _PresetPickerSection(
                  title: 'Presets (Dark tone)',
                  presets: presets
                      .where((p) => p.toneBrightness == Brightness.dark)
                      .toList(),
                  selectedPresetId: selectedPresetId,
                  onSelect: (id) {
                    if (id != null) controller.setPalettePreset(id);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PresetPickerSection extends StatelessWidget {
  final String title;
  final List<PalettePreset> presets;
  final String? selectedPresetId;
  final ValueChanged<String?> onSelect;

  const _PresetPickerSection({
    required this.title,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.text.titleSmall),
        SizedBox(height: s.xs),
        Wrap(
          spacing: s.sm,
          runSpacing: s.sm,
          children: [
            for (final p in presets)
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
        ),
      ],
    );
  }
}

class _BrandPickerSection extends StatelessWidget {
  final String title;
  final String? selectedBrandId;
  final ValueChanged<String> onSelect;

  const _BrandPickerSection({
    required this.title,
    required this.selectedBrandId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    final options = BrandDefaults.options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.text.titleSmall),
        SizedBox(height: s.xs),
        Wrap(
          spacing: s.sm,
          runSpacing: s.sm,
          children: [
            for (final o in options)
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
        children: [
          Expanded(child: ColoredBox(color: left)),
          Expanded(child: ColoredBox(color: right)),
        ],
      ),
    );
  }
}

@immutable
class _ColorSwatch extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _ColorSwatch({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    return Container(
      padding: context.dsSpacing.symmetric(horizontal: s.md, vertical: s.sm),
      decoration: BoxDecoration(color: bg, borderRadius: context.dsRadii.sm),
      child: Text(label, style: context.text.labelLarge?.copyWith(color: fg)),
    );
  }
}

@immutable
class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  const _KeyValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;
    return Padding(
      padding: context.dsSpacing.only(bottom: s.xs),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: context.text.bodyMedium)),
          Text(value, style: context.text.bodySmall),
        ],
      ),
    );
  }
}
