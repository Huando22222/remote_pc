import 'package:flutter/material.dart';
import 'app_font_weights.dart';

/// Tất cả TextStyle của app — không phụ thuộc màu
/// Màu sẽ được inject từ [AppTextStylesExtension] theo theme
///
/// Naming convention:
///   displayXL / displayLG / displayMD
///   headingXL / headingLG / headingMD / headingSM / headingXS
///   bodyLG / bodyMD / bodySM / bodyXS
///   labelLG / labelMD / labelSM
///   codeLG  / codeMD  / codeSM      ← đặc thù Remote Desktop (hostname, IP, command)
///   captionMD / captionSM

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Inter';
  static const String _fontFamilyMono =
      'JetBrainsMono'; // dùng cho code/IP/hostname

  // ─────────────────────────────────────────────
  // DISPLAY — tên màn hình, splash, hero section
  // ─────────────────────────────────────────────

  static const TextStyle displayXL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -1.5,
    height: 1.1,
  );

  static const TextStyle displayLG = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 40,
    fontWeight: AppFontWeights.bold,
    letterSpacing: -1.0,
    height: 1.15,
  );

  static const TextStyle displayMD = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ─────────────────────────────────────────────
  // HEADING — section title, card title, dialog
  // ─────────────────────────────────────────────

  static const TextStyle headingXL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle headingLG = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: -0.2,
    height: 1.35,
  );

  static const TextStyle headingMD = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static const TextStyle headingSM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle headingXS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: AppFontWeights.semiBold,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // ─────────────────────────────────────────────
  // BODY — nội dung chính, description, tooltip
  // ─────────────────────────────────────────────

  static const TextStyle bodyLG = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: AppFontWeights.regular,
    letterSpacing: 0,
    height: 1.6,
  );

  static const TextStyle bodyMD = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: AppFontWeights.regular,
    letterSpacing: 0,
    height: 1.57,
  );

  static const TextStyle bodySM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: AppFontWeights.regular,
    letterSpacing: 0,
    height: 1.54,
  );

  static const TextStyle bodyXS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: AppFontWeights.regular,
    letterSpacing: 0,
    height: 1.5,
  );

  // ─────────────────────────────────────────────
  // LABEL — button, tab, badge, tag, nav item
  // ─────────────────────────────────────────────

  static const TextStyle labelLG = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: AppFontWeights.medium,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle labelMD = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: AppFontWeights.medium,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle labelSM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: AppFontWeights.medium,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // ─────────────────────────────────────────────
  // CODE — hostname, IP address, command, path
  // Đặc thù Remote Desktop app
  // ─────────────────────────────────────────────

  static const TextStyle codeLG = TextStyle(
    fontFamily: _fontFamilyMono,
    fontSize: 15,
    fontWeight: AppFontWeights.regular,
    letterSpacing: -0.2,
    height: 1.6,
  );

  static const TextStyle codeMD = TextStyle(
    fontFamily: _fontFamilyMono,
    fontSize: 13,
    fontWeight: AppFontWeights.regular,
    letterSpacing: -0.1,
    height: 1.55,
  );

  static const TextStyle codeSM = TextStyle(
    fontFamily: _fontFamilyMono,
    fontSize: 11,
    fontWeight: AppFontWeights.regular,
    letterSpacing: 0,
    height: 1.5,
  );

  // ─────────────────────────────────────────────
  // CAPTION — timestamp, helper text, metadata
  // ─────────────────────────────────────────────

  static const TextStyle captionMD = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: AppFontWeights.regular,
    letterSpacing: 0.2,
    height: 1.5,
  );

  static const TextStyle captionSM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: AppFontWeights.regular,
    letterSpacing: 0.3,
    height: 1.45,
  );
}
