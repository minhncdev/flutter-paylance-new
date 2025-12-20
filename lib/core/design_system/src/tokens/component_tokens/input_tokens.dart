/// Input primitive tokens (raw values only).
/// - For TextField/Dropdown/Search, etc.
/// - No InputDecoration/EdgeInsets/TextStyle here.
library;

import 'package:flutter/material.dart';

import '../radius_tokens.dart';
import '../size_tokens.dart';
import '../spacing_tokens.dart';

@immutable
class InputTokens {
  /// Control heights.
  static const double heightSm = 40;
  static const double heightMd = 48;
  static const double heightLg = 56;

  /// Corner radius for input containers.
  static const double radius = RadiusTokens.r12;

  /// Horizontal padding inside controls.
  static const double paddingX = SpacingTokens.s12;

  /// Vertical padding inside controls (if needed by resolver).
  static const double paddingY = SpacingTokens.s10;

  /// Gap between leading icon and text.
  static const double leadingGap = SpacingTokens.s8;

  /// Icon size for leading/trailing icons.
  static const double iconSize = SizeTokens.sz20;

  /// Border/stroke width.
  static const double strokeWidth = 1.0;

  /// Helper/error text spacing from field.
  static const double assistiveGap = SpacingTokens.s6;

  const InputTokens._();
}
