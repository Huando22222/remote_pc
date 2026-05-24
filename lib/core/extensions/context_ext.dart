import 'package:flutter/material.dart';

import 'color_scheme_ext.dart';

extension ContextExt on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  LinearGradient get primaryGradient => colorScheme.primaryGradient;
  LinearGradient get primaryGradientSubtle => colorScheme.primaryGradientSubtle;
  LinearGradient get imageOverlayGradient => colorScheme.imageOverlayGradient;
  List<BoxShadow> get softShadow => colorScheme.softShadow;
}
