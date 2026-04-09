import 'package:flutter/material.dart';

/// Application colors using enum
enum AppColors {
  lightGrey(Color(0xFFE0E0E0)),
  white(Color(0xFFFFFFFF)),
  textBlue(Color(0xFF28294D)),
  success(Color(0xFF4CAF50)),
  warning(Color(0xFFFFC107)),
  background(Color(0xFFF5F5F5)),
  textPrimary(Color(0xFF212121)),
  textSecondary(Color(0xFF757575));

  final Color color;

  const AppColors(this.color);
}
