// sandbox/ds_gallery/pages/ds_gallery_feedback_page.dart
//
// Feedback preview: snackbars, toasts, dialogs, bottom sheets, loading, empty state.

library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../widgets/ds_gallery_section.dart';

@immutable
class DsGalleryFeedbackPage extends StatefulWidget {
  const DsGalleryFeedbackPage({super.key});

  @override
  State<DsGalleryFeedbackPage> createState() => _DsGalleryFeedbackPageState();
}

class _DsGalleryFeedbackPageState extends State<DsGalleryFeedbackPage> {
  OverlayEntry? _toastEntry;
  Timer? _toastTimer;

  @override
  void dispose() {
    _toastTimer?.cancel();
    _toastEntry?.remove();
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

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return ListView(
      padding: context.dsSpacing.all(s.pagePadding),
      children: <Widget>[
        DsGallerySection(
          title: 'Snackbars & Toasts',
          description: 'Trigger feedback components.',
          child: Wrap(
            spacing: s.sm,
            runSpacing: s.sm,
            children: <Widget>[
              AppButton(
                label: 'Snack: Success',
                variant: AppButtonVariant.secondary,
                onPressed: () =>
                    _showSnackBar(context, AppFeedbackTone.success),
              ),
              AppButton(
                label: 'Snack: Danger',
                variant: AppButtonVariant.outline,
                onPressed: () => _showSnackBar(context, AppFeedbackTone.danger),
              ),
              AppButton(
                label: 'Toast: Info',
                variant: AppButtonVariant.tonal,
                onPressed: () => _showToast(context, AppToastTone.info),
              ),
            ],
          ),
        ),
        SizedBox(height: s.xl),
        DsGallerySection(
          title: 'Dialogs & Sheets',
          description: 'Validate overlays & surfaces.',
          child: Wrap(
            spacing: s.sm,
            runSpacing: s.sm,
            children: <Widget>[
              AppButton(
                label: 'Show Alert Dialog',
                variant: AppButtonVariant.primary,
                onPressed: () => _showAlertDialog(context),
              ),
              AppButton(
                label: 'Show Bottom Sheet',
                variant: AppButtonVariant.secondary,
                onPressed: () => _showBottomSheet(context),
              ),
            ],
          ),
        ),
        SizedBox(height: s.xl),
        DsGallerySection(
          title: 'Loading & Empty state',
          description: 'Inline loading + empty layout.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const AppLoading(centered: false, label: 'Inline loading'),
              SizedBox(height: s.lg),
              AppEmptyState(
                title: 'Empty state',
                description:
                    'This is an example empty state for content absence.',
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
          ),
        ),
      ],
    );
  }
}
