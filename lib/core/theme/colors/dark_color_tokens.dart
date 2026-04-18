import 'package:flutter/material.dart';
import 'color_palette.dart';

/// Semantic color tokens cho Dark theme
/// Map từ [ColorPalette] sang ý nghĩa ngữ nghĩa

class DarkColorTokens {
  DarkColorTokens._();

  // ── Background ──────────────────────────────
  static const Color bgPrimary = ColorPalette.darkBase;
  static const Color bgSecondary = ColorPalette.dark100;
  static const Color bgTertiary = ColorPalette.dark150;
  static const Color bgOverlay = Color(0xCC0D1117);

  // ── Surface ─────────────────────────────────
  static const Color surfaceDefault = ColorPalette.dark100;
  static const Color surfaceRaised = ColorPalette.dark50;
  static const Color surfaceSunken = ColorPalette.darkDeep;

  // ── Brand ────────────────────────────────────
  static const Color brandPrimary = ColorPalette.blue500;
  static const Color brandSecondary = ColorPalette.blue400;
  static const Color brandSubtle = ColorPalette.blue900;

  // ── Status ───────────────────────────────────
  static const Color statusConnected = ColorPalette.green400;
  static const Color statusIdle = ColorPalette.yellow400;
  static const Color statusError = ColorPalette.red400;
  static const Color statusOffline = ColorPalette.gray500;

  // ── Text ─────────────────────────────────────
  static const Color textPrimary = ColorPalette.dark900;
  static const Color textSecondary = ColorPalette.dark700;
  static const Color textTertiary = ColorPalette.dark500;
  static const Color textOnBrand = ColorPalette.white;
  static const Color textLink = ColorPalette.blue400;

  // ── Border ───────────────────────────────────
  static const Color borderDefault = ColorPalette.dark300;
  static const Color borderStrong = ColorPalette.dark400;
  static const Color borderFocus = ColorPalette.blue500;

  // ── Remote Session ───────────────────────────
  static const Color sessionBar = ColorPalette.darkVoid;
  static const Color sessionBarText = ColorPalette.dark800;
  static const Color sessionHandle = ColorPalette.blue500;
  static const Color sessionShadow = Color(0x333B82F6);

  // ── Button ───────────────────────────────────
  static const Color btnPrimaryBg = ColorPalette.blue500;
  static const Color btnPrimaryText = ColorPalette.white;
  static const Color btnPrimaryHover = ColorPalette.blue600;
  static const Color btnSecondaryBg = ColorPalette.dark50;
  static const Color btnSecondaryText = ColorPalette.dark900;
  static const Color btnSecondaryBorder = ColorPalette.dark300;
  static const Color btnDangerBg = ColorPalette.red800;
  static const Color btnDangerText = ColorPalette.red100;
}
