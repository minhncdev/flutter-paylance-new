/// ThemeExtension that exposes DS component style metrics (non-widget, non-ThemeData).
/// - Token-driven: consumes component tokens + foundations.
/// - Provides raw metrics and optional computed values.
/// - Helps keep component styling consistent and centralized.
library;

import 'package:flutter/material.dart';

import '../../foundations/app_shape.dart';
import '../../foundations/app_spacing.dart';
import '../../tokens/component_tokens/button_tokens.dart';
import '../../tokens/component_tokens/card_tokens.dart';
import '../../tokens/component_tokens/input_tokens.dart';
import '../../tokens/component_tokens/navigation_tokens.dart';

@immutable
class ButtonMetrics {
  final double heightSm;
  final double heightMd;
  final double heightLg;

  final double radiusSm;
  final double radiusMd;
  final double radiusLg;

  final double paddingXSm;
  final double paddingXMd;
  final double paddingXLg;

  final double paddingYSm;
  final double paddingYMd;
  final double paddingYLg;

  final double contentGap;
  final double iconSm;
  final double iconMd;
  final double iconLg;

  final double strokeWidth;

  const ButtonMetrics({
    required this.heightSm,
    required this.heightMd,
    required this.heightLg,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.paddingXSm,
    required this.paddingXMd,
    required this.paddingXLg,
    required this.paddingYSm,
    required this.paddingYMd,
    required this.paddingYLg,
    required this.contentGap,
    required this.iconSm,
    required this.iconMd,
    required this.iconLg,
    required this.strokeWidth,
  });

  factory ButtonMetrics.fromTokens({
    required AppShape shape,
    required AppSpacing spacing,
  }) {
    // Uses component tokens (raw) while allowing shape/spacing to override if desired later.
    return const ButtonMetrics(
      heightSm: ButtonTokens.heightSm,
      heightMd: ButtonTokens.heightMd,
      heightLg: ButtonTokens.heightLg,
      radiusSm: ButtonTokens.radiusSm,
      radiusMd: ButtonTokens.radiusMd,
      radiusLg: ButtonTokens.radiusLg,
      paddingXSm: ButtonTokens.paddingXSm,
      paddingXMd: ButtonTokens.paddingXMd,
      paddingXLg: ButtonTokens.paddingXLg,
      paddingYSm: ButtonTokens.paddingYSm,
      paddingYMd: ButtonTokens.paddingYMd,
      paddingYLg: ButtonTokens.paddingYLg,
      contentGap: ButtonTokens.contentGap,
      iconSm: ButtonTokens.iconSm,
      iconMd: ButtonTokens.iconMd,
      iconLg: ButtonTokens.iconLg,
      strokeWidth: ButtonTokens.strokeWidth,
    );
  }
}

@immutable
class CardMetrics {
  final double radius;
  final double paddingSm;
  final double paddingMd;
  final double paddingLg;
  final double borderWidth;
  final double sectionGap;

  const CardMetrics({
    required this.radius,
    required this.paddingSm,
    required this.paddingMd,
    required this.paddingLg,
    required this.borderWidth,
    required this.sectionGap,
  });

  factory CardMetrics.fromTokens({
    required AppShape shape,
    required AppSpacing spacing,
  }) {
    return const CardMetrics(
      radius: CardTokens.radius,
      paddingSm: CardTokens.paddingSm,
      paddingMd: CardTokens.paddingMd,
      paddingLg: CardTokens.paddingLg,
      borderWidth: CardTokens.borderWidth,
      sectionGap: CardTokens.sectionGap,
    );
  }
}

@immutable
class InputMetrics {
  final double heightSm;
  final double heightMd;
  final double heightLg;

  final double radius;
  final double paddingX;
  final double paddingY;

  final double leadingGap;
  final double iconSize;

  final double strokeWidth;
  final double assistiveGap;

  const InputMetrics({
    required this.heightSm,
    required this.heightMd,
    required this.heightLg,
    required this.radius,
    required this.paddingX,
    required this.paddingY,
    required this.leadingGap,
    required this.iconSize,
    required this.strokeWidth,
    required this.assistiveGap,
  });

  factory InputMetrics.fromTokens({
    required AppShape shape,
    required AppSpacing spacing,
  }) {
    return const InputMetrics(
      heightSm: InputTokens.heightSm,
      heightMd: InputTokens.heightMd,
      heightLg: InputTokens.heightLg,
      radius: InputTokens.radius,
      paddingX: InputTokens.paddingX,
      paddingY: InputTokens.paddingY,
      leadingGap: InputTokens.leadingGap,
      iconSize: InputTokens.iconSize,
      strokeWidth: InputTokens.strokeWidth,
      assistiveGap: InputTokens.assistiveGap,
    );
  }
}

@immutable
class NavigationMetrics {
  final double appBarHeight;
  final double bottomBarHeight;
  final double tabBarHeight;
  final double navRailWidth;

  final double navIconSize;
  final double itemGap;
  final double itemPaddingX;

  const NavigationMetrics({
    required this.appBarHeight,
    required this.bottomBarHeight,
    required this.tabBarHeight,
    required this.navRailWidth,
    required this.navIconSize,
    required this.itemGap,
    required this.itemPaddingX,
  });

  factory NavigationMetrics.fromTokens() {
    return const NavigationMetrics(
      appBarHeight: NavigationTokens.appBarHeight,
      bottomBarHeight: NavigationTokens.bottomBarHeight,
      tabBarHeight: NavigationTokens.tabBarHeight,
      navRailWidth: NavigationTokens.navRailWidth,
      navIconSize: NavigationTokens.navIconSize,
      itemGap: NavigationTokens.itemGap,
      itemPaddingX: NavigationTokens.itemPaddingX,
    );
  }
}

@immutable
class DsComponentStylesExt extends ThemeExtension<DsComponentStylesExt> {
  final ButtonMetrics button;
  final CardMetrics card;
  final InputMetrics input;
  final NavigationMetrics navigation;

  const DsComponentStylesExt({
    required this.button,
    required this.card,
    required this.input,
    required this.navigation,
  });

  factory DsComponentStylesExt.base({
    required AppShape shape,
    required AppSpacing spacing,
  }) {
    return DsComponentStylesExt(
      button: ButtonMetrics.fromTokens(shape: shape, spacing: spacing),
      card: CardMetrics.fromTokens(shape: shape, spacing: spacing),
      input: InputMetrics.fromTokens(shape: shape, spacing: spacing),
      navigation: NavigationMetrics.fromTokens(),
    );
  }

  @override
  DsComponentStylesExt copyWith({
    ButtonMetrics? button,
    CardMetrics? card,
    InputMetrics? input,
    NavigationMetrics? navigation,
  }) {
    return DsComponentStylesExt(
      button: button ?? this.button,
      card: card ?? this.card,
      input: input ?? this.input,
      navigation: navigation ?? this.navigation,
    );
  }

  @override
  DsComponentStylesExt lerp(
    ThemeExtension<DsComponentStylesExt>? other,
    double t,
  ) {
    // Metrics are discrete; keep stable through transitions.
    if (other is! DsComponentStylesExt) return this;
    return t < 0.5 ? this : other;
  }
}
