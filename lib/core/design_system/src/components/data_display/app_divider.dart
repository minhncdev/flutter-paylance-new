/// DS Divider primitive.
/// - Theme-driven divider using ColorScheme + DS stroke width.
/// - Stateless and composition-friendly.
library;

import 'package:flutter/material.dart';

import '../../theme/theme_extensions/ds_extensions.dart';

@immutable
class AppDivider extends StatelessWidget {
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final double? height;

  const AppDivider({
    super.key,
    this.thickness,
    this.indent,
    this.endIndent,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shape = context.dsRadii.shape;

    return Divider(
      color: scheme.outlineVariant,
      thickness: thickness ?? shape.strokeThin,
      indent: indent,
      endIndent: endIndent,
      height: height,
    );
  }
}
