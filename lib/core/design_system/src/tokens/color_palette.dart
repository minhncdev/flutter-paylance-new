/// Primitive color palette tokens (no semantic meaning).
/// - This layer provides only raw colors (scales) to support multi-brand theming.
/// - Do NOT put semantic roles here (e.g., background, surface, primary).
library;

import 'package:flutter/material.dart';

@immutable
class ColorScale {
  /// Supported keys: 0, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950.
  final Color c0;
  final Color c50;
  final Color c100;
  final Color c200;
  final Color c300;
  final Color c400;
  final Color c500;
  final Color c600;
  final Color c700;
  final Color c800;
  final Color c900;
  final Color c950;

  const ColorScale({
    required this.c0,
    required this.c50,
    required this.c100,
    required this.c200,
    required this.c300,
    required this.c400,
    required this.c500,
    required this.c600,
    required this.c700,
    required this.c800,
    required this.c900,
    required this.c950,
  });

  /// Returns the shade by key. Falls back to 500 when unknown.
  Color shade(int key) {
    switch (key) {
      case 0:
        return c0;
      case 50:
        return c50;
      case 100:
        return c100;
      case 200:
        return c200;
      case 300:
        return c300;
      case 400:
        return c400;
      case 500:
        return c500;
      case 600:
        return c600;
      case 700:
        return c700;
      case 800:
        return c800;
      case 900:
        return c900;
      case 950:
        return c950;
      default:
        return c500;
    }
  }

  /// Convenience operator for `palette.neutral[100]`.
  Color operator [](int key) => shade(key);
}

/// A set of primitive color scales. Brands can choose which scales to map into
/// semantic roles at a higher layer (foundations/theme).
@immutable
class PrimitivePalettes {
  final ColorScale neutral;
  final ColorScale blue;
  final ColorScale teal;
  final ColorScale green;
  final ColorScale amber;
  final ColorScale red;
  final ColorScale purple;

  const PrimitivePalettes({
    required this.neutral,
    required this.blue,
    required this.teal,
    required this.green,
    required this.amber,
    required this.red,
    required this.purple,
  });

  /// Default primitive palette set.
  ///
  /// Notes:
  /// - Values are intentionally generic and brand-agnostic.
  /// - Brand selection/mapping belongs to semantic layers (NOT here).
  static const PrimitivePalettes base = PrimitivePalettes(
    neutral: ColorScale(
      c0: Color(0xFFFFFFFF),
      c50: Color(0xFFF9FAFB),
      c100: Color(0xFFF3F4F6),
      c200: Color(0xFFE5E7EB),
      c300: Color(0xFFD1D5DB),
      c400: Color(0xFF9CA3AF),
      c500: Color(0xFF6B7280),
      c600: Color(0xFF4B5563),
      c700: Color(0xFF374151),
      c800: Color(0xFF1F2937),
      c900: Color(0xFF111827),
      c950: Color(0xFF0B1220),
    ),
    blue: ColorScale(
      c0: Color(0xFFF5FAFF),
      c50: Color(0xFFEAF3FF),
      c100: Color(0xFFD6E9FF),
      c200: Color(0xFFADD3FF),
      c300: Color(0xFF7FB8FF),
      c400: Color(0xFF4E97FF),
      c500: Color(0xFF246BFD),
      c600: Color(0xFF1B54D9),
      c700: Color(0xFF153FAF),
      c800: Color(0xFF102E83),
      c900: Color(0xFF0B1F5B),
      c950: Color(0xFF081744),
    ),
    teal: ColorScale(
      c0: Color(0xFFF2FFFB),
      c50: Color(0xFFE6FFF7),
      c100: Color(0xFFCCFFEF),
      c200: Color(0xFF99F6E4),
      c300: Color(0xFF5EEAD4),
      c400: Color(0xFF2DD4BF),
      c500: Color(0xFF14B8A6),
      c600: Color(0xFF0D9488),
      c700: Color(0xFF0F766E),
      c800: Color(0xFF115E59),
      c900: Color(0xFF134E4A),
      c950: Color(0xFF083A37),
    ),
    green: ColorScale(
      c0: Color(0xFFF2FFF5),
      c50: Color(0xFFE9FBEF),
      c100: Color(0xFFD1FADF),
      c200: Color(0xFFA7F3C2),
      c300: Color(0xFF6EE7A5),
      c400: Color(0xFF34D399),
      c500: Color(0xFF10B981),
      c600: Color(0xFF059669),
      c700: Color(0xFF047857),
      c800: Color(0xFF065F46),
      c900: Color(0xFF064E3B),
      c950: Color(0xFF053A2C),
    ),
    amber: ColorScale(
      c0: Color(0xFFFFFBEB),
      c50: Color(0xFFFFF7D6),
      c100: Color(0xFFFFEFB0),
      c200: Color(0xFFFDE68A),
      c300: Color(0xFFFCD34D),
      c400: Color(0xFFFBBF24),
      c500: Color(0xFFF59E0B),
      c600: Color(0xFFD97706),
      c700: Color(0xFFB45309),
      c800: Color(0xFF92400E),
      c900: Color(0xFF78350F),
      c950: Color(0xFF5A2A0C),
    ),
    red: ColorScale(
      c0: Color(0xFFFFF5F5),
      c50: Color(0xFFFFEBEB),
      c100: Color(0xFFFFD6D6),
      c200: Color(0xFFFECACA),
      c300: Color(0xFFFCA5A5),
      c400: Color(0xFFF87171),
      c500: Color(0xFFEF4444),
      c600: Color(0xFFDC2626),
      c700: Color(0xFFB91C1C),
      c800: Color(0xFF991B1B),
      c900: Color(0xFF7F1D1D),
      c950: Color(0xFF5F1515),
    ),
    purple: ColorScale(
      c0: Color(0xFFFAF5FF),
      c50: Color(0xFFF3E8FF),
      c100: Color(0xFFE9D5FF),
      c200: Color(0xFFD8B4FE),
      c300: Color(0xFFC084FC),
      c400: Color(0xFFA855F7),
      c500: Color(0xFF8B5CF6),
      c600: Color(0xFF7C3AED),
      c700: Color(0xFF6D28D9),
      c800: Color(0xFF5B21B6),
      c900: Color(0xFF4C1D95),
      c950: Color(0xFF36126B),
    ),
  );
}
