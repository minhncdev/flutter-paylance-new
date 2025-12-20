/// Card primitive tokens (raw values only).
/// - No Shape/BoxShadow/Theme usage here.
library;

import 'package:flutter/material.dart';

import '../radius_tokens.dart';
import '../spacing_tokens.dart';

@immutable
class CardTokens {
  /// Default corner radius.
  static const double radius = RadiusTokens.r16;

  /// Internal padding (raw).
  static const double paddingSm = SpacingTokens.s12;
  static const double paddingMd = SpacingTokens.s16;
  static const double paddingLg = SpacingTokens.s20;

  /// Border width for outlined cards.
  static const double borderWidth = 1.0;

  /// Spacing between sections inside a card.
  static const double sectionGap = SpacingTokens.s12;

  const CardTokens._();
}
