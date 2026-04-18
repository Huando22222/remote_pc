import 'package:flutter/material.dart';

/// Primitive color tokens — KHÔNG dùng trực tiếp trong widget
/// Chỉ được tham chiếu bởi [LightColorTokens] và [DarkColorTokens]

class ColorPalette {
  ColorPalette._();

  // Blue scale
  static const Color blue50 = Color(0xFFE0ECFF);
  static const Color blue100 = Color(0xFFBFD9FF);
  static const Color blue200 = Color(0xFF93BFFF);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF0A6EFA);
  static const Color blue800 = Color(0xFF0052CC);
  static const Color blue900 = Color(0xFF1E3A5F);

  // Slate (neutral cool)
  static const Color slate50 = Color(0xFFF8F9FB);
  static const Color slate100 = Color(0xFFF0F2F5);
  static const Color slate150 = Color(0xFFE8EBF0);
  static const Color slate200 = Color(0xFFE4E7ED);
  static const Color slate300 = Color(0xFFD1D9E4);
  static const Color slate400 = Color(0xFF9FB0C7);
  static const Color slate500 = Color(0xFF94A3B8);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate900 = Color(0xFF0F172A);

  // GitHub dark scale
  static const Color dark50 = Color(0xFF1C2330);
  static const Color dark100 = Color(0xFF161B22);
  static const Color dark150 = Color(0xFF1F2733);
  static const Color dark200 = Color(0xFF252E3D);
  static const Color dark300 = Color(0xFF30363D);
  static const Color dark400 = Color(0xFF484F58);
  static const Color dark500 = Color(0xFF4D5566);
  static const Color dark600 = Color(0xFF6B7280);
  static const Color dark700 = Color(0xFF8B949E);
  static const Color dark800 = Color(0xFFC9D1D9);
  static const Color dark900 = Color(0xFFE6EDF3);
  static const Color darkBase = Color(0xFF0D1117);
  static const Color darkDeep = Color(0xFF0A0E13);
  static const Color darkVoid = Color(0xFF090D12);

  // Green
  static const Color green500 = Color(0xFF16A34A);
  static const Color green400 = Color(0xFF22C55E);

  // Yellow
  static const Color yellow500 = Color(0xFFCA8A04);
  static const Color yellow400 = Color(0xFFEAB308);

  // Red
  static const Color red500 = Color(0xFFDC2626);
  static const Color red400 = Color(0xFFF87171);
  static const Color red800 = Color(0xFF991B1B);
  static const Color red100 = Color(0xFFFEE2E2);

  // Gray
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);

  // Session special
  static const Color sessionDark = Color(0xFF1E293B);
  static const Color sessionDeep = Color(0xFF090D12);
  static const Color textOnSessionDark = Color(0xFFE2E8F0);

  // Pure
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
}
