import 'package:flutter/material.dart';

extension SafeOpacity on Color {
  Color withSafeOpacity(double opacity) {
    return withValues(alpha: opacity.clamp(0.0, 1.0));
  }
}
