/// Button primitive tokens (raw values only).
/// - No EdgeInsets/Shape/TextStyle.
/// - Components/themes will interpret these values via resolvers/extensions.
library;

import 'package:flutter/material.dart';

import '../radius_tokens.dart';
import '../size_tokens.dart';
import '../spacing_tokens.dart';

@immutable
class ButtonTokens {
  /// Heights per size.
  static const double heightSm = 36;
  static const double heightMd = 44;
  static const double heightLg = 52;

  /// Corner radii.
  static const double radiusSm = RadiusTokens.r8;
  static const double radiusMd = RadiusTokens.r12;
  static const double radiusLg = RadiusTokens.r16;

  /// Horizontal padding per size (raw).
  static const double paddingXSm = SpacingTokens.s12;
  static const double paddingXMd = SpacingTokens.s16;
  static const double paddingXLg = SpacingTokens.s20;

  /// Vertical padding per size (raw).
  static const double paddingYSm = SpacingTokens.s8;
  static const double paddingYMd = SpacingTokens.s10;
  static const double paddingYLg = SpacingTokens.s12;

  /// Content gap between icon and label.
  static const double contentGap = SpacingTokens.s8;

  /// Icon sizes inside buttons.
  static const double iconSm = SizeTokens.sz16;
  static const double iconMd = SizeTokens.sz20;
  static const double iconLg = SizeTokens.sz24;

  /// Stroke width for outlined buttons / focus rings (mapping elsewhere).
  static const double strokeWidth = 1.0;

  const ButtonTokens._();
}
