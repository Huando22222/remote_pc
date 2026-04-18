import 'package:flutter/material.dart';
import 'app_colors_extension.dart';
import 'app_text_styles_extension.dart';

/// Shortcut extensions trên [BuildContext]
/// Thay vì: Theme.of(context).extension<AppColorsExtension>()!
/// Dùng:    context.appColors.brandPrimary
///
/// Thay vì: Theme.of(context).extension<AppTextStylesExtension>()!
/// Dùng:    context.appTextStyles.bodyMD

extension AppColorsContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}

extension AppTextStylesContext on BuildContext {
  AppTextStylesExtension get appTextStyles =>
      Theme.of(this).extension<AppTextStylesExtension>()!;
}
