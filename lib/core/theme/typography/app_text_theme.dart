import 'package:flutter/material.dart';
import 'app_text_styles.dart';

/// Map [AppTextStyles] sang [TextTheme] Flutter
/// Để các widget Material tự lấy đúng typography (AppBar, Dialog, Button...)
///
/// Mapping logic:
///   displayLarge   ← displayXL
///   displayMedium  ← displayLG
///   displaySmall   ← displayMD
///   headlineLarge  ← headingXL
///   headlineMedium ← headingLG
///   headlineSmall  ← headingMD
///   titleLarge     ← headingMD   (AppBar title)
///   titleMedium    ← headingSM   (list tile title)
///   titleSmall     ← headingXS
///   bodyLarge      ← bodyLG
///   bodyMedium     ← bodyMD      (default Text widget)
///   bodySmall      ← bodySM
///   labelLarge     ← labelLG     (ElevatedButton)
///   labelMedium    ← labelMD     (TextButton, chip)
///   labelSmall     ← labelSM     (badge, overline)

class AppTextTheme {
  AppTextTheme._();

  static const TextTheme textTheme = TextTheme(
    displayLarge: AppTextStyles.displayXL,
    displayMedium: AppTextStyles.displayLG,
    displaySmall: AppTextStyles.displayMD,

    headlineLarge: AppTextStyles.headingXL,
    headlineMedium: AppTextStyles.headingLG,
    headlineSmall: AppTextStyles.headingMD,

    titleLarge: AppTextStyles.headingMD,
    titleMedium: AppTextStyles.headingSM,
    titleSmall: AppTextStyles.headingXS,

    bodyLarge: AppTextStyles.bodyLG,
    bodyMedium: AppTextStyles.bodyMD,
    bodySmall: AppTextStyles.bodySM,

    labelLarge: AppTextStyles.labelLG,
    labelMedium: AppTextStyles.labelMD,
    labelSmall: AppTextStyles.labelSM,
  );
}
