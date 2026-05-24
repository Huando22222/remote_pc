import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTypography.textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.primaryGradientEnd,
        onSecondary: AppColors.white,
        tertiary: AppColors.success,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.successLight,
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: AppColors.errorLight,
        surface: AppColors.white,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        surfaceContainerLowest: AppColors.white,
        surfaceContainerLow: AppColors.backgroundLight,
        surfaceContainer: AppColors.backgroundLight,
        surfaceContainerHigh: Color(0xFFF0F4FF),
        surfaceContainerHighest: AppColors.backgroundLight,
        outline: AppColors.border,
        outlineVariant: AppColors.borderVariant,
        inverseSurface: AppColors.textPrimary,
        onInverseSurface: AppColors.white,
        inversePrimary: AppColors.primaryLight,
        shadow: Color(0x1A000000),
        scrim: Color(0x99000000),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        shadowColor: AppColors.border,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.white,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: _inputTheme(
        fillColor: AppColors.white,
        borderColor: AppColors.border,
        focusedColor: AppColors.primary,
        errorColor: AppColors.error,
        hintColor: AppColors.textDisabled,
        labelColor: AppColors.textSecondary,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppTypography.textTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primaryContainerDark,
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.primaryGradientEnd,
        onSecondary: AppColors.black,
        secondaryContainer: AppColors.secondaryContainerDark,
        tertiary: AppColors.success,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.tertiaryContainerDark,
        error: AppColors.errorDark,
        onError: AppColors.black,
        errorContainer: AppColors.errorContainerDark,
        onErrorContainer: AppColors.onErrorContainerDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
        onSurfaceVariant: AppColors.onSurfaceVariantDark,
        surfaceContainerLowest: AppColors.backgroundDark,
        surfaceContainerLow: AppColors.surfaceDark,
        surfaceContainer: AppColors.surfaceContainerDark,
        surfaceContainerHigh: AppColors.surfaceContainerHighDark,
        surfaceContainerHighest: AppColors.surfaceContainerHighDark,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.borderVariantDark,
        inverseSurface: AppColors.inverseSurfaceDark,
        onInverseSurface: AppColors.onInverseSurfaceDark,
        inversePrimary: AppColors.inversePrimaryDark,
        shadow: Color(0x33000000),
        scrim: Color(0xCC000000),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onSurfaceDark,
        shadowColor: AppColors.borderDark,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: AppColors.onSurfaceDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceDark,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: _inputTheme(
        fillColor: AppColors.surfaceContainerDark,
        borderColor: AppColors.borderDark,
        focusedColor: AppColors.primary,
        errorColor: AppColors.errorDark,
        hintColor: AppColors.onSurfaceVariantDark,
        labelColor: AppColors.onSurfaceVariantDark,
      ),
    );
  }

  static InputDecorationTheme _inputTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusedColor,
    required Color errorColor,
    required Color hintColor,
    required Color labelColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: focusedColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: errorColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: hintColor,
      ),
      labelStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: labelColor,
      ),
      errorStyle: AppTypography.textTheme.bodySmall?.copyWith(
        color: errorColor,
      ),
    );
  }
}
