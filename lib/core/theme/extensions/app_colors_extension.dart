import 'package:flutter/material.dart';
import '../colors/light_color_tokens.dart';
import '../colors/dark_color_tokens.dart';

/// ThemeExtension chứa tất cả màu custom của app
/// Đăng ký trong [AppTheme] — dùng qua [Theme.of(context).appColors]

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    // Background
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.bgOverlay,
    // Surface
    required this.surfaceDefault,
    required this.surfaceRaised,
    required this.surfaceSunken,
    // Brand
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandSubtle,
    // Status
    required this.statusConnected,
    required this.statusIdle,
    required this.statusError,
    required this.statusOffline,
    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnBrand,
    required this.textLink,
    // Border
    required this.borderDefault,
    required this.borderStrong,
    required this.borderFocus,
    // Session
    required this.sessionBar,
    required this.sessionBarText,
    required this.sessionHandle,
    required this.sessionShadow,
    // Button
    required this.btnPrimaryBg,
    required this.btnPrimaryText,
    required this.btnPrimaryHover,
    required this.btnSecondaryBg,
    required this.btnSecondaryText,
    required this.btnSecondaryBorder,
    required this.btnDangerBg,
    required this.btnDangerText,
  });

  // ── Background ──────────────────────────────
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgTertiary;
  final Color bgOverlay;

  // ── Surface ─────────────────────────────────
  final Color surfaceDefault;
  final Color surfaceRaised;
  final Color surfaceSunken;

  // ── Brand ────────────────────────────────────
  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandSubtle;

  // ── Status ───────────────────────────────────
  final Color statusConnected;
  final Color statusIdle;
  final Color statusError;
  final Color statusOffline;

  // ── Text ─────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnBrand;
  final Color textLink;

  // ── Border ───────────────────────────────────
  final Color borderDefault;
  final Color borderStrong;
  final Color borderFocus;

  // ── Remote Session ───────────────────────────
  final Color sessionBar;
  final Color sessionBarText;
  final Color sessionHandle;
  final Color sessionShadow;

  // ── Button ───────────────────────────────────
  final Color btnPrimaryBg;
  final Color btnPrimaryText;
  final Color btnPrimaryHover;
  final Color btnSecondaryBg;
  final Color btnSecondaryText;
  final Color btnSecondaryBorder;
  final Color btnDangerBg;
  final Color btnDangerText;

  // ── Preset instances ─────────────────────────

  static const AppColorsExtension light = AppColorsExtension(
    bgPrimary: LightColorTokens.bgPrimary,
    bgSecondary: LightColorTokens.bgSecondary,
    bgTertiary: LightColorTokens.bgTertiary,
    bgOverlay: LightColorTokens.bgOverlay,
    surfaceDefault: LightColorTokens.surfaceDefault,
    surfaceRaised: LightColorTokens.surfaceRaised,
    surfaceSunken: LightColorTokens.surfaceSunken,
    brandPrimary: LightColorTokens.brandPrimary,
    brandSecondary: LightColorTokens.brandSecondary,
    brandSubtle: LightColorTokens.brandSubtle,
    statusConnected: LightColorTokens.statusConnected,
    statusIdle: LightColorTokens.statusIdle,
    statusError: LightColorTokens.statusError,
    statusOffline: LightColorTokens.statusOffline,
    textPrimary: LightColorTokens.textPrimary,
    textSecondary: LightColorTokens.textSecondary,
    textTertiary: LightColorTokens.textTertiary,
    textOnBrand: LightColorTokens.textOnBrand,
    textLink: LightColorTokens.textLink,
    borderDefault: LightColorTokens.borderDefault,
    borderStrong: LightColorTokens.borderStrong,
    borderFocus: LightColorTokens.borderFocus,
    sessionBar: LightColorTokens.sessionBar,
    sessionBarText: LightColorTokens.sessionBarText,
    sessionHandle: LightColorTokens.sessionHandle,
    sessionShadow: LightColorTokens.sessionShadow,
    btnPrimaryBg: LightColorTokens.btnPrimaryBg,
    btnPrimaryText: LightColorTokens.btnPrimaryText,
    btnPrimaryHover: LightColorTokens.btnPrimaryHover,
    btnSecondaryBg: LightColorTokens.btnSecondaryBg,
    btnSecondaryText: LightColorTokens.btnSecondaryText,
    btnSecondaryBorder: LightColorTokens.btnSecondaryBorder,
    btnDangerBg: LightColorTokens.btnDangerBg,
    btnDangerText: LightColorTokens.btnDangerText,
  );

  static const AppColorsExtension dark = AppColorsExtension(
    bgPrimary: DarkColorTokens.bgPrimary,
    bgSecondary: DarkColorTokens.bgSecondary,
    bgTertiary: DarkColorTokens.bgTertiary,
    bgOverlay: DarkColorTokens.bgOverlay,
    surfaceDefault: DarkColorTokens.surfaceDefault,
    surfaceRaised: DarkColorTokens.surfaceRaised,
    surfaceSunken: DarkColorTokens.surfaceSunken,
    brandPrimary: DarkColorTokens.brandPrimary,
    brandSecondary: DarkColorTokens.brandSecondary,
    brandSubtle: DarkColorTokens.brandSubtle,
    statusConnected: DarkColorTokens.statusConnected,
    statusIdle: DarkColorTokens.statusIdle,
    statusError: DarkColorTokens.statusError,
    statusOffline: DarkColorTokens.statusOffline,
    textPrimary: DarkColorTokens.textPrimary,
    textSecondary: DarkColorTokens.textSecondary,
    textTertiary: DarkColorTokens.textTertiary,
    textOnBrand: DarkColorTokens.textOnBrand,
    textLink: DarkColorTokens.textLink,
    borderDefault: DarkColorTokens.borderDefault,
    borderStrong: DarkColorTokens.borderStrong,
    borderFocus: DarkColorTokens.borderFocus,
    sessionBar: DarkColorTokens.sessionBar,
    sessionBarText: DarkColorTokens.sessionBarText,
    sessionHandle: DarkColorTokens.sessionHandle,
    sessionShadow: DarkColorTokens.sessionShadow,
    btnPrimaryBg: DarkColorTokens.btnPrimaryBg,
    btnPrimaryText: DarkColorTokens.btnPrimaryText,
    btnPrimaryHover: DarkColorTokens.btnPrimaryHover,
    btnSecondaryBg: DarkColorTokens.btnSecondaryBg,
    btnSecondaryText: DarkColorTokens.btnSecondaryText,
    btnSecondaryBorder: DarkColorTokens.btnSecondaryBorder,
    btnDangerBg: DarkColorTokens.btnDangerBg,
    btnDangerText: DarkColorTokens.btnDangerText,
  );

  // ── ThemeExtension overrides ──────────────────

  @override
  AppColorsExtension copyWith({
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgTertiary,
    Color? bgOverlay,
    Color? surfaceDefault,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? brandPrimary,
    Color? brandSecondary,
    Color? brandSubtle,
    Color? statusConnected,
    Color? statusIdle,
    Color? statusError,
    Color? statusOffline,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textOnBrand,
    Color? textLink,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderFocus,
    Color? sessionBar,
    Color? sessionBarText,
    Color? sessionHandle,
    Color? sessionShadow,
    Color? btnPrimaryBg,
    Color? btnPrimaryText,
    Color? btnPrimaryHover,
    Color? btnSecondaryBg,
    Color? btnSecondaryText,
    Color? btnSecondaryBorder,
    Color? btnDangerBg,
    Color? btnDangerText,
  }) {
    return AppColorsExtension(
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      bgOverlay: bgOverlay ?? this.bgOverlay,
      surfaceDefault: surfaceDefault ?? this.surfaceDefault,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandSubtle: brandSubtle ?? this.brandSubtle,
      statusConnected: statusConnected ?? this.statusConnected,
      statusIdle: statusIdle ?? this.statusIdle,
      statusError: statusError ?? this.statusError,
      statusOffline: statusOffline ?? this.statusOffline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnBrand: textOnBrand ?? this.textOnBrand,
      textLink: textLink ?? this.textLink,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderFocus: borderFocus ?? this.borderFocus,
      sessionBar: sessionBar ?? this.sessionBar,
      sessionBarText: sessionBarText ?? this.sessionBarText,
      sessionHandle: sessionHandle ?? this.sessionHandle,
      sessionShadow: sessionShadow ?? this.sessionShadow,
      btnPrimaryBg: btnPrimaryBg ?? this.btnPrimaryBg,
      btnPrimaryText: btnPrimaryText ?? this.btnPrimaryText,
      btnPrimaryHover: btnPrimaryHover ?? this.btnPrimaryHover,
      btnSecondaryBg: btnSecondaryBg ?? this.btnSecondaryBg,
      btnSecondaryText: btnSecondaryText ?? this.btnSecondaryText,
      btnSecondaryBorder: btnSecondaryBorder ?? this.btnSecondaryBorder,
      btnDangerBg: btnDangerBg ?? this.btnDangerBg,
      btnDangerText: btnDangerText ?? this.btnDangerText,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t)!,
      bgOverlay: Color.lerp(bgOverlay, other.bgOverlay, t)!,
      surfaceDefault: Color.lerp(surfaceDefault, other.surfaceDefault, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandSubtle: Color.lerp(brandSubtle, other.brandSubtle, t)!,
      statusConnected: Color.lerp(statusConnected, other.statusConnected, t)!,
      statusIdle: Color.lerp(statusIdle, other.statusIdle, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusOffline: Color.lerp(statusOffline, other.statusOffline, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      sessionBar: Color.lerp(sessionBar, other.sessionBar, t)!,
      sessionBarText: Color.lerp(sessionBarText, other.sessionBarText, t)!,
      sessionHandle: Color.lerp(sessionHandle, other.sessionHandle, t)!,
      sessionShadow: Color.lerp(sessionShadow, other.sessionShadow, t)!,
      btnPrimaryBg: Color.lerp(btnPrimaryBg, other.btnPrimaryBg, t)!,
      btnPrimaryText: Color.lerp(btnPrimaryText, other.btnPrimaryText, t)!,
      btnPrimaryHover: Color.lerp(btnPrimaryHover, other.btnPrimaryHover, t)!,
      btnSecondaryBg: Color.lerp(btnSecondaryBg, other.btnSecondaryBg, t)!,
      btnSecondaryText:
          Color.lerp(btnSecondaryText, other.btnSecondaryText, t)!,
      btnSecondaryBorder:
          Color.lerp(btnSecondaryBorder, other.btnSecondaryBorder, t)!,
      btnDangerBg: Color.lerp(btnDangerBg, other.btnDangerBg, t)!,
      btnDangerText: Color.lerp(btnDangerText, other.btnDangerText, t)!,
    );
  }
}
