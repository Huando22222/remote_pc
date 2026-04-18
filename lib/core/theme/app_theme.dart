import 'package:flutter/material.dart';
import 'colors/light_color_tokens.dart';
import 'colors/dark_color_tokens.dart';
import 'typography/app_text_theme.dart';
import 'extensions/app_colors_extension.dart';
import 'extensions/app_text_styles_extension.dart';

/// Factory tạo [ThemeData] — đăng ký cả color + typography extension
///
/// Dùng trong [MaterialApp]:
/// ```dart
/// MaterialApp(
///   theme:     AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────
  // LIGHT
  // ─────────────────────────────────────────
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: LightColorTokens.brandPrimary,
      onPrimary: LightColorTokens.textOnBrand,
      secondary: LightColorTokens.brandSecondary,
      onSecondary: LightColorTokens.textOnBrand,
      surface: LightColorTokens.surfaceDefault,
      onSurface: LightColorTokens.textPrimary,
      error: LightColorTokens.statusError,
      onError: LightColorTokens.textOnBrand,
      outline: LightColorTokens.borderDefault,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: LightColorTokens.textPrimary,
        displayColor: LightColorTokens.textPrimary,
      ),
      scaffoldBackgroundColor: LightColorTokens.bgPrimary,
      extensions: const [
        AppColorsExtension.light,
        AppTextStylesExtension.light, // ← typography extension
      ],
    );
  }

  // ─────────────────────────────────────────
  // DARK
  // ─────────────────────────────────────────
  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: DarkColorTokens.brandPrimary,
      onPrimary: DarkColorTokens.textOnBrand,
      secondary: DarkColorTokens.brandSecondary,
      onSecondary: DarkColorTokens.textOnBrand,
      surface: DarkColorTokens.surfaceDefault,
      onSurface: DarkColorTokens.textPrimary,
      error: DarkColorTokens.statusError,
      onError: DarkColorTokens.textOnBrand,
      outline: DarkColorTokens.borderDefault,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: DarkColorTokens.textPrimary,
        displayColor: DarkColorTokens.textPrimary,
      ),
      scaffoldBackgroundColor: DarkColorTokens.bgPrimary,
      extensions: const [
        AppColorsExtension.dark,
        AppTextStylesExtension.dark, // ← typography extension
      ],
    );
  }
}
