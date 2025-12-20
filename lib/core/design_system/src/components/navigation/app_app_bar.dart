/// DS AppBar primitive.
/// - No routing logic. App layer controls callbacks (e.g., back navigation).
/// - Token/theme-driven via Material 3 ThemeData + DS navigation metrics.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

@immutable
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;

  final Widget? leading;
  final bool showBack;
  final VoidCallback? onBack;

  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  final bool centerTitle;

  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.showBack = false,
    this.onBack,
    this.actions,
    this.bottom,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize {
    // Cannot access BuildContext here; return typical base height and include bottom.
    // Actual toolbarHeight is set in build using DS tokens.
    return Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nav = context.dsComponents.navigation;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final Widget? resolvedTitle =
        titleWidget ??
        (title != null
            ? Text(
                title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              )
            : null);

    final Widget? resolvedLeading =
        leading ??
        (showBack
            ? BackButton(onPressed: onBack, color: scheme.onSurface)
            : null);

    return AppBar(
      toolbarHeight: nav.appBarHeight,
      centerTitle: centerTitle,
      title: resolvedTitle,
      leading: resolvedLeading,
      actions: actions,
      bottom: bottom,
    );
  }
}
