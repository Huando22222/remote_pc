import 'package:flutter/material.dart';
import 'package:pc_remote/core/theme/app_colors.dart';

extension ColorSchemeExt on ColorScheme {
  LinearGradient get primaryGradient {
    return LinearGradient(
      colors: [
        primary,
        AppColors.primaryGradientEnd,
      ],
    );
  }

  LinearGradient get primaryGradientSubtle {
    return LinearGradient(
      colors: [
        primaryContainer,
        surface,
      ],
    );
  }

  LinearGradient get imageOverlayGradient {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Color(0x99000000),
      ],
    );
  }

  List<BoxShadow> get softShadow {
    return brightness == Brightness.dark
        ? const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 24,
              offset: Offset(0, 4),
            ),
          ]
        : AppColors.softShadow;
  }
}
