import 'package:flutter/material.dart';
import 'color_palette.dart';

/// Semantic color tokens cho Light theme
/// Map từ [ColorPalette] sang ý nghĩa ngữ nghĩa

class LightColorTokens {
  LightColorTokens._();

  // ── Background ──────────────────────────────
  static const Color bgPrimary = ColorPalette.slate100;
  static const Color bgSecondary = ColorPalette.white;
  static const Color bgTertiary = ColorPalette.slate200;
  static const Color bgOverlay = Color(0xCCFFFFFF);

  // ── Surface ─────────────────────────────────
  static const Color surfaceDefault = ColorPalette.white;
  static const Color surfaceRaised = ColorPalette.slate50;
  static const Color surfaceSunken = ColorPalette.slate150;

  // ── Brand ────────────────────────────────────
  static const Color brandPrimary = ColorPalette.blue700;
  static const Color brandSecondary = ColorPalette.blue800;
  static const Color brandSubtle = ColorPalette.blue50;

  // ── Status ───────────────────────────────────
  static const Color statusConnected = ColorPalette.green500;
  static const Color statusIdle = ColorPalette.yellow500;
  static const Color statusError = ColorPalette.red500;
  static const Color statusOffline = ColorPalette.gray400;

  // ── Text ─────────────────────────────────────
  static const Color textPrimary = ColorPalette.slate900;
  static const Color textSecondary = ColorPalette.slate600;
  static const Color textTertiary = ColorPalette.slate500;
  static const Color textOnBrand = ColorPalette.white;
  static const Color textLink = ColorPalette.blue700;

  // ── Border ───────────────────────────────────
  static const Color borderDefault = ColorPalette.slate300;
  static const Color borderStrong = ColorPalette.slate400;
  static const Color borderFocus = ColorPalette.blue700;

  // ── Remote Session ───────────────────────────
  static const Color sessionBar = ColorPalette.sessionDark;
  static const Color sessionBarText = ColorPalette.textOnSessionDark;
  static const Color sessionHandle = ColorPalette.blue700;
  static const Color sessionShadow = Color(0x260A6EFA);

  // ── Button ───────────────────────────────────
  static const Color btnPrimaryBg = ColorPalette.blue700;
  static const Color btnPrimaryText = ColorPalette.white;
  static const Color btnPrimaryHover = ColorPalette.blue800;
  static const Color btnSecondaryBg = ColorPalette.white;
  static const Color btnSecondaryText = ColorPalette.slate900;
  static const Color btnSecondaryBorder = ColorPalette.slate300;
  static const Color btnDangerBg = ColorPalette.red500;
  static const Color btnDangerText = ColorPalette.white;
}
