import 'dart:async';
import 'package:flutter/material.dart';

enum TouchpadPhase {
  idle,
  tap1, // 1 ngón xuống, chưa di, chờ long-press hoặc tap
  longPress, // long-press đã kích hoạt → mouseDown giữ, chờ di
  drag, // đang bôi đen: mouseDown + di chuột
  move, // 1 ngón di chuột bình thường (không mouseDown)
  tap2, // 2 ngón xuống, chưa di → chờ right-click / scroll
  scroll, // 2 ngón đang cuộn
  swipe, // 3+ ngón
}

class TouchpadState {
  final Map<int, Offset> activePointers = {};
  int peakCount = 0;

  TouchpadPhase phase = TouchpadPhase.idle;

  Offset totalDelta = Offset.zero;
  double moveDistance = 0.0;

  DateTime? downTime;
  DateTime? lastTapUp; // thời điểm nhả tap gần nhất → detect double-tap

  Timer? longPressTimer; // hết giờ → mouseDown → phase = longPress

  int get fingerCount => activePointers.length;

  void addPointer(int id, Offset pos) {
    activePointers[id] = pos;
    if (activePointers.length > peakCount) peakCount = activePointers.length;
  }

  void removePointer(int id) => activePointers.remove(id);
  void updatePointer(int id, Offset pos) => activePointers[id] = pos;
  bool hasPointer(int id) => activePointers.containsKey(id);

  void cancelLongPress() {
    longPressTimer?.cancel();
    longPressTimer = null;
  }

  // Reset gesture, GIỮ lastTapUp để double-tap vẫn detect được
  void resetGesture() {
    cancelLongPress();
    activePointers.clear();
    peakCount = 0;
    phase = TouchpadPhase.idle;
    totalDelta = Offset.zero;
    moveDistance = 0.0;
    downTime = null;
  }

  void resetAll() {
    resetGesture();
    lastTapUp = null;
  }
}
