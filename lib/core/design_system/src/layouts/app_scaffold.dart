/// DS AppScaffold layout primitive:
/// - Wraps Scaffold with consistent DS padding/safe-area patterns.
/// - No business logic, no feature references.
/// - Accessible defaults: respects system insets, supports scroll behavior selection.
library;

import 'package:flutter/material.dart';

import '../theme/theme_extensions/ds_extensions.dart';
import 'page_padding.dart';
import 'safe_area_wrapper.dart';

enum AppScaffoldBodyBehavior {
  /// Body is placed as-is.
  plain,

  /// Wrap body in PagePadding (common for fintech pages).
  padded,

  /// Wrap body in PagePadding + SafeArea (common for full-screen layouts).
  paddedSafe,
}

@immutable
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final FloatingActionButton? floatingActionButton;

  final AppScaffoldBodyBehavior bodyBehavior;

  /// Whether to extend body behind AppBar (for immersive layouts).
  final bool extendBodyBehindAppBar;

  /// Whether to extend body behind bottom bar.
  final bool extendBody;

  /// Optional semantics label for screen readers.
  final String? semanticsLabel;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.bodyBehavior = AppScaffoldBodyBehavior.padded,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget content = body;

    switch (bodyBehavior) {
      case AppScaffoldBodyBehavior.plain:
        // no-op
        break;
      case AppScaffoldBodyBehavior.padded:
        content = PagePadding(child: content);
        break;
      case AppScaffoldBodyBehavior.paddedSafe:
        content = SafeAreaWrapper.pagePadded(child: content);
        break;
    }

    // Provide a semantics container to improve screen navigation for assistive tech.
    final semanticsWrapped = Semantics(
      container: true,
      label: semanticsLabel,
      child: content,
    );

    return Scaffold(
      backgroundColor: scheme.background,
      appBar: appBar,
      body: semanticsWrapped,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
    );
  }
}
