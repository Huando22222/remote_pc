import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF2F80ED);
  static const primaryLight = Color(0xFFEBF3FF);
  static const primaryDark = Color(0xFF1C5BB2);
  static const primaryGradientEnd = Color(0xFF4F9EF7);

  static const success = Color(0xFF27AE60);
  static const successLight = Color(0xFFE9F7EF);
  static const warning = Color(0xFFF2994A);
  static const warningLight = Color(0xFFFEF3E7);

  static const error = Color(0xFFEB5757);
  static const errorLight = Color(0xFFFDECEC);
  static const errorDark = Color(0xFFFF6B6B);
  static const errorContainerDark = Color(0xFF4A1A1A);
  static const onErrorContainerDark = Color(0xFFFFB4B4);

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  static const backgroundLight = Color(0xFFF8FAFE);
  static const border = Color(0xFFE0E0E0);
  static const borderVariant = Color(0xFFEEEEEE);
  static const textPrimary = Color(0xFF1A1C1C);
  static const textSecondary = Color(0xFF666666);
  static const textDisabled = Color(0xFF9E9E9E);

  static const backgroundDark = Color(0xFF121212);
  static const surfaceDark = Color(0xFF1E1E2E);
  static const surfaceContainerDark = Color(0xFF252538);
  static const surfaceContainerHighDark = Color(0xFF2A2A3E);
  static const borderDark = Color(0xFF2A2A3E);
  static const borderVariantDark = Color(0xFF3A3A5C);
  static const onSurfaceDark = Color(0xFFE8EAED);
  static const onSurfaceVariantDark = Color(0xFFBDBDBD);

  static const primaryContainerDark = Color(0xFF1A3A6E);
  static const secondaryContainerDark = Color(0xFF0D3A4A);
  static const tertiaryContainerDark = Color(0xFF0D2A3A);
  static const inverseSurfaceDark = Color(0xFFE8EAED);
  static const onInverseSurfaceDark = Color(0xFF1E1E2E);
  static const inversePrimaryDark = Color(0xFF1C5BB2);

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 24,
      offset: Offset(0, 4),
    ),
  ];
}
