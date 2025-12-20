// app/theme/theme_cache.dart
//
// Small cache for ThemeData built from presetId + brightness.

library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class ThemeCacheKey {
  final String presetId;
  final Brightness brightness;

  const ThemeCacheKey(this.presetId, this.brightness);

  @override
  bool operator ==(Object other) =>
      other is ThemeCacheKey &&
      other.presetId == presetId &&
      other.brightness == brightness;

  @override
  int get hashCode => Object.hash(presetId, brightness);
}

class ThemeCache {
  final Map<ThemeCacheKey, ThemeData> _cache = <ThemeCacheKey, ThemeData>{};

  ThemeData getOrBuild({
    required String presetId,
    required Brightness brightness,
    required ThemeData Function() build,
  }) {
    final key = ThemeCacheKey(presetId, brightness);
    final hit = _cache[key];
    if (hit != null) return hit;

    final built = build();
    _cache[key] = built;
    return built;
  }

  void invalidate({String? presetId}) {
    if (presetId == null) {
      _cache.clear();
      return;
    }
    _cache.removeWhere((k, _) => k.presetId == presetId);
  }

  @visibleForTesting
  void clear() => _cache.clear();
}
