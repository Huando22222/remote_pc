import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    return GoogleFonts.beVietnamProTextTheme().copyWith(
      displayLarge: _style(57, FontWeight.w700),
      displayMedium: _style(45, FontWeight.w700),
      displaySmall: _style(36, FontWeight.w600),
      headlineLarge: _style(32, FontWeight.w600),
      headlineMedium: _style(28, FontWeight.w600),
      headlineSmall: _style(24, FontWeight.w600),
      titleLarge: _style(20, FontWeight.w600),
      titleMedium: _style(16, FontWeight.w500),
      titleSmall: _style(14, FontWeight.w500),
      bodyLarge: _style(16, FontWeight.w400),
      bodyMedium: _style(14, FontWeight.w400),
      bodySmall: _style(12, FontWeight.w400),
      labelLarge: _style(14, FontWeight.w600, letterSpacing: 0.5),
      labelMedium: _style(12, FontWeight.w500, letterSpacing: 0.5),
      labelSmall: _style(11, FontWeight.w500, letterSpacing: 0.5),
    );
  }

  static TextStyle _style(
    double size,
    FontWeight weight, {
    double letterSpacing = 0,
    double height = 1.5,
  }) {
    return GoogleFonts.beVietnamPro(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
