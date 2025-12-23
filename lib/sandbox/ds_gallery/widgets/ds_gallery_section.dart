// sandbox/ds_gallery/widgets/ds_gallery_section.dart
//
// Small layout helper for DS Gallery pages.
// - Standardizes spacing + section title + optional description + card wrapper.

library;

import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

@immutable
class DsGallerySection extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;
  final AppCardVariant cardVariant;

  const DsGallerySection({
    super.key,
    required this.title,
    this.description,
    required this.child,
    this.cardVariant = AppCardVariant.filled,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.dsSpacing.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: context.text.titleLarge),
        if (description != null) ...[
          SizedBox(height: s.xs),
          Text(description!, style: context.text.bodyMedium),
        ],
        SizedBox(height: s.sm),
        AppCard(variant: cardVariant, child: child),
      ],
    );
  }
}
