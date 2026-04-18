// presentation/widgets/touchpad_state.dart

import 'package:pc_remote/features/remote_control/domain/entities/scroll_axis.dart';

class TouchpadState {
  // ── pointer ──────────────────────────────────
  int fingers = 0;
  bool isDragging = false;
  bool didMove = false;
  double totalMove = 0;

  // ── scroll 2 ngón ────────────────────────────
  ScrollAxis? scrollAxis;
  bool twoFingerTap = false;
  bool twoFingerMoved = false;

  // ── swipe 3+ ngón ────────────────────────────
  bool isSwipeGesture = false;
  int swipeFingers = 0;
  double swipeDx = 0;
  double swipeDy = 0;

  // ── tap timing ───────────────────────────────
  DateTime? downTime;
  DateTime? lastTapTime;

  // ── reset helpers ────────────────────────────
  void resetScroll() {
    scrollAxis = null;
    twoFingerTap = false;
    twoFingerMoved = false;
  }

  void resetSwipe() {
    isSwipeGesture = false;
    swipeFingers = 0;
    swipeDx = 0;
    swipeDy = 0;
  }

  void resetTap() {
    didMove = false;
    totalMove = 0;
  }
}
