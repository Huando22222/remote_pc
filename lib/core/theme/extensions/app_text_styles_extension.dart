import 'package:flutter/material.dart';
import '../typography/app_text_styles.dart';
import '../colors/light_color_tokens.dart';
import '../colors/dark_color_tokens.dart';

/// ThemeExtension inject màu vào TextStyle
/// Mỗi style có sẵn màu đúng theo theme — dùng trực tiếp không cần set màu thủ công
///
/// Dùng qua context extension: context.appTextStyles.bodyMD
/// Hoặc:  Theme.of(context).extension<AppTextStylesExtension>()!.bodyMD

@immutable
class AppTextStylesExtension extends ThemeExtension<AppTextStylesExtension> {
  const AppTextStylesExtension({
    // Display
    required this.displayXL,
    required this.displayLG,
    required this.displayMD,
    // Heading
    required this.headingXL,
    required this.headingLG,
    required this.headingMD,
    required this.headingSM,
    required this.headingXS,
    // Body
    required this.bodyLG,
    required this.bodyMD,
    required this.bodySM,
    required this.bodyXS,
    // Label
    required this.labelLG,
    required this.labelMD,
    required this.labelSM,
    // Code
    required this.codeLG,
    required this.codeMD,
    required this.codeSM,
    // Caption
    required this.captionMD,
    required this.captionSM,
    // Variants (secondary, tertiary, link, onBrand)
    required this.bodyMDSecondary,
    required this.bodyMDTertiary,
    required this.bodyMDLink,
    required this.labelMDOnBrand,
    required this.codeMDMuted,
  });

  // Display
  final TextStyle displayXL;
  final TextStyle displayLG;
  final TextStyle displayMD;

  // Heading
  final TextStyle headingXL;
  final TextStyle headingLG;
  final TextStyle headingMD;
  final TextStyle headingSM;
  final TextStyle headingXS;

  // Body
  final TextStyle bodyLG;
  final TextStyle bodyMD;
  final TextStyle bodySM;
  final TextStyle bodyXS;

  // Label
  final TextStyle labelLG;
  final TextStyle labelMD;
  final TextStyle labelSM;

  // Code (hostname, IP, path — Remote Desktop specific)
  final TextStyle codeLG;
  final TextStyle codeMD;
  final TextStyle codeSM;

  // Caption
  final TextStyle captionMD;
  final TextStyle captionSM;

  // Semantic variants (màu khác nhau, cùng size)
  final TextStyle bodyMDSecondary; // textSecondary
  final TextStyle bodyMDTertiary; // textTertiary
  final TextStyle bodyMDLink; // textLink + underline
  final TextStyle labelMDOnBrand; // trắng — dùng trên button brand
  final TextStyle codeMDMuted; // code mờ — placeholder IP

  // ── Preset: Light ─────────────────────────────

  static const AppTextStylesExtension light = AppTextStylesExtension(
    displayXL: AppTextStyles.displayXL,
    displayLG: AppTextStyles.displayLG,
    displayMD: AppTextStyles.displayMD,

    headingXL: AppTextStyles.headingXL,
    headingLG: AppTextStyles.headingLG,
    headingMD: AppTextStyles.headingMD,
    headingSM: AppTextStyles.headingSM,
    headingXS: AppTextStyles.headingXS,

    bodyLG: AppTextStyles.bodyLG,
    bodyMD: AppTextStyles.bodyMD,
    bodySM: AppTextStyles.bodySM,
    bodyXS: AppTextStyles.bodyXS,

    labelLG: AppTextStyles.labelLG,
    labelMD: AppTextStyles.labelMD,
    labelSM: AppTextStyles.labelSM,

    codeLG: AppTextStyles.codeLG,
    codeMD: AppTextStyles.codeMD,
    codeSM: AppTextStyles.codeSM,

    captionMD: AppTextStyles.captionMD,
    captionSM: AppTextStyles.captionSM,

    bodyMDSecondary: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.57,
      color: LightColorTokens.textSecondary,
    ),
    bodyMDTertiary: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.57,
      color: LightColorTokens.textTertiary,
    ),
    bodyMDLink: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.57,
      color: LightColorTokens.textLink,
      decoration: TextDecoration.underline,
      decorationColor: LightColorTokens.textLink,
    ),
    labelMDOnBrand: TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4,
      color: LightColorTokens.textOnBrand,
    ),
    codeMDMuted: TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.1,
      height: 1.55,
      color: LightColorTokens.textTertiary,
    ),
  );

  // ── Preset: Dark ──────────────────────────────

  static const AppTextStylesExtension dark = AppTextStylesExtension(
    displayXL: AppTextStyles.displayXL,
    displayLG: AppTextStyles.displayLG,
    displayMD: AppTextStyles.displayMD,

    headingXL: AppTextStyles.headingXL,
    headingLG: AppTextStyles.headingLG,
    headingMD: AppTextStyles.headingMD,
    headingSM: AppTextStyles.headingSM,
    headingXS: AppTextStyles.headingXS,

    bodyLG: AppTextStyles.bodyLG,
    bodyMD: AppTextStyles.bodyMD,
    bodySM: AppTextStyles.bodySM,
    bodyXS: AppTextStyles.bodyXS,

    labelLG: AppTextStyles.labelLG,
    labelMD: AppTextStyles.labelMD,
    labelSM: AppTextStyles.labelSM,

    codeLG: AppTextStyles.codeLG,
    codeMD: AppTextStyles.codeMD,
    codeSM: AppTextStyles.codeSM,

    captionMD: AppTextStyles.captionMD,
    captionSM: AppTextStyles.captionSM,

    bodyMDSecondary: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.57,
      color: DarkColorTokens.textSecondary,
    ),
    bodyMDTertiary: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.57,
      color: DarkColorTokens.textTertiary,
    ),
    bodyMDLink: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.57,
      color: DarkColorTokens.textLink,
      decoration: TextDecoration.underline,
      decorationColor: DarkColorTokens.textLink,
    ),
    labelMDOnBrand: TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4,
      color: DarkColorTokens.textOnBrand,
    ),
    codeMDMuted: TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.1,
      height: 1.55,
      color: DarkColorTokens.textTertiary,
    ),
  );

  // ── ThemeExtension overrides ──────────────────

  @override
  AppTextStylesExtension copyWith({
    TextStyle? displayXL,
    TextStyle? displayLG,
    TextStyle? displayMD,
    TextStyle? headingXL,
    TextStyle? headingLG,
    TextStyle? headingMD,
    TextStyle? headingSM,
    TextStyle? headingXS,
    TextStyle? bodyLG,
    TextStyle? bodyMD,
    TextStyle? bodySM,
    TextStyle? bodyXS,
    TextStyle? labelLG,
    TextStyle? labelMD,
    TextStyle? labelSM,
    TextStyle? codeLG,
    TextStyle? codeMD,
    TextStyle? codeSM,
    TextStyle? captionMD,
    TextStyle? captionSM,
    TextStyle? bodyMDSecondary,
    TextStyle? bodyMDTertiary,
    TextStyle? bodyMDLink,
    TextStyle? labelMDOnBrand,
    TextStyle? codeMDMuted,
  }) {
    return AppTextStylesExtension(
      displayXL: displayXL ?? this.displayXL,
      displayLG: displayLG ?? this.displayLG,
      displayMD: displayMD ?? this.displayMD,
      headingXL: headingXL ?? this.headingXL,
      headingLG: headingLG ?? this.headingLG,
      headingMD: headingMD ?? this.headingMD,
      headingSM: headingSM ?? this.headingSM,
      headingXS: headingXS ?? this.headingXS,
      bodyLG: bodyLG ?? this.bodyLG,
      bodyMD: bodyMD ?? this.bodyMD,
      bodySM: bodySM ?? this.bodySM,
      bodyXS: bodyXS ?? this.bodyXS,
      labelLG: labelLG ?? this.labelLG,
      labelMD: labelMD ?? this.labelMD,
      labelSM: labelSM ?? this.labelSM,
      codeLG: codeLG ?? this.codeLG,
      codeMD: codeMD ?? this.codeMD,
      codeSM: codeSM ?? this.codeSM,
      captionMD: captionMD ?? this.captionMD,
      captionSM: captionSM ?? this.captionSM,
      bodyMDSecondary: bodyMDSecondary ?? this.bodyMDSecondary,
      bodyMDTertiary: bodyMDTertiary ?? this.bodyMDTertiary,
      bodyMDLink: bodyMDLink ?? this.bodyMDLink,
      labelMDOnBrand: labelMDOnBrand ?? this.labelMDOnBrand,
      codeMDMuted: codeMDMuted ?? this.codeMDMuted,
    );
  }

  @override
  AppTextStylesExtension lerp(AppTextStylesExtension? other, double t) {
    if (other is! AppTextStylesExtension) return this;
    return AppTextStylesExtension(
      displayXL: TextStyle.lerp(displayXL, other.displayXL, t)!,
      displayLG: TextStyle.lerp(displayLG, other.displayLG, t)!,
      displayMD: TextStyle.lerp(displayMD, other.displayMD, t)!,
      headingXL: TextStyle.lerp(headingXL, other.headingXL, t)!,
      headingLG: TextStyle.lerp(headingLG, other.headingLG, t)!,
      headingMD: TextStyle.lerp(headingMD, other.headingMD, t)!,
      headingSM: TextStyle.lerp(headingSM, other.headingSM, t)!,
      headingXS: TextStyle.lerp(headingXS, other.headingXS, t)!,
      bodyLG: TextStyle.lerp(bodyLG, other.bodyLG, t)!,
      bodyMD: TextStyle.lerp(bodyMD, other.bodyMD, t)!,
      bodySM: TextStyle.lerp(bodySM, other.bodySM, t)!,
      bodyXS: TextStyle.lerp(bodyXS, other.bodyXS, t)!,
      labelLG: TextStyle.lerp(labelLG, other.labelLG, t)!,
      labelMD: TextStyle.lerp(labelMD, other.labelMD, t)!,
      labelSM: TextStyle.lerp(labelSM, other.labelSM, t)!,
      codeLG: TextStyle.lerp(codeLG, other.codeLG, t)!,
      codeMD: TextStyle.lerp(codeMD, other.codeMD, t)!,
      codeSM: TextStyle.lerp(codeSM, other.codeSM, t)!,
      captionMD: TextStyle.lerp(captionMD, other.captionMD, t)!,
      captionSM: TextStyle.lerp(captionSM, other.captionSM, t)!,
      bodyMDSecondary:
          TextStyle.lerp(bodyMDSecondary, other.bodyMDSecondary, t)!,
      bodyMDTertiary: TextStyle.lerp(bodyMDTertiary, other.bodyMDTertiary, t)!,
      bodyMDLink: TextStyle.lerp(bodyMDLink, other.bodyMDLink, t)!,
      labelMDOnBrand: TextStyle.lerp(labelMDOnBrand, other.labelMDOnBrand, t)!,
      codeMDMuted: TextStyle.lerp(codeMDMuted, other.codeMDMuted, t)!,
    );
  }
}
