import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pc_remote/features/remote_control/domain/entities/scroll_axis.dart';
import 'package:pc_remote/features/remote_control/domain/entities/scroll_delta.dart';
import 'package:pc_remote/features/remote_control/domain/entities/swipe_gesture.dart';
import 'package:pc_remote/features/remote_control/presentation/widgets/touchpad_state.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/double_click_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/mouse_down_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/mouse_up_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/right_click_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/scroll_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/swipe_usecase.dart';
import '../../domain/entities/mouse_move.dart';
import '../../domain/usecases/move_mouse_usecase.dart';
import '../../domain/usecases/left_click_usecase.dart';

class TouchpadWidget extends StatefulWidget {
  final MoveMouseUseCase moveMouse;
  final LeftClickUseCase clickMouse;
  final RightClickUseCase rightClickMouse;
  final DoubleClickUseCase doubleClickMouse;
  final MouseDownUseCase mouseDown;
  final MouseUpUseCase mouseUp;
  final ScrollUseCase scrollMouse;
  final SwipeUseCase swipe;

  const TouchpadWidget({
    super.key,
    required this.moveMouse,
    required this.clickMouse,
    required this.rightClickMouse,
    required this.doubleClickMouse,
    required this.mouseDown,
    required this.mouseUp,
    required this.scrollMouse,
    required this.swipe,
  });

  @override
  State<TouchpadWidget> createState() => _TouchpadWidgetState();
}

class _TouchpadWidgetState extends State<TouchpadWidget> {
  final _s = TouchpadState();
  Timer? _dragTimer;

  // ── constants ───────────────────────────────
  static const _dragDelay = Duration(milliseconds: 500);
  static const _doubleTapWindow = Duration(milliseconds: 300);
  static const _twoFingerWindow = Duration(milliseconds: 180);
  static const _moveThreshold = 10.0;
  static const _swipeThreshold = 25.0;
  static const _axisLockRatio = 1.5; // hướng phải rõ hơn 1.5x mới lock

  // ── drag ────────────────────────────────────
  void _startDrag() {
    if (_s.isDragging) return;
    _s.isDragging = true;
    HapticFeedback.mediumImpact();
    widget.mouseDown();
  }

  void _stopDrag() {
    if (!_s.isDragging) return;
    _s.isDragging = false;
    _s.fingers = (_s.fingers - 1).clamp(0, 10);
    widget.mouseUp();
    widget.moveMouse(MouseMove(dx: 0, dy: 0));
  }

  // ── scroll ───────────────────────────────────
  void _handleScroll(PointerMoveEvent e) {
    _s.twoFingerTap = false;
    _s.twoFingerMoved = true;

    // lock hướng từ event đầu tiên đủ rõ
    if (_s.scrollAxis == null) {
      final absDx = e.delta.dx.abs();
      final absDy = e.delta.dy.abs();

      if (absDx > absDy * _axisLockRatio) {
        _s.scrollAxis = ScrollAxis.horizontal;
      } else if (absDy > absDx * _axisLockRatio) {
        _s.scrollAxis = ScrollAxis.vertical;
      } else {
        return; // chưa rõ hướng → bỏ qua
      }
    }

    switch (_s.scrollAxis!) {
      case ScrollAxis.horizontal:
        widget.scrollMouse(ScrollDelta(dx: e.delta.dx * -10, dy: 0));
      case ScrollAxis.vertical:
        widget.scrollMouse(ScrollDelta(dx: 0, dy: e.delta.dy * -3));
    }
  }

  // ── swipe ────────────────────────────────────
  void _detectSwipe() {
    final dx = _s.swipeDx;
    final dy = _s.swipeDy;

    if (dx.abs() < _swipeThreshold && dy.abs() < _swipeThreshold) {
      _s.resetSwipe();
      return;
    }

    final direction = dy.abs() > dx.abs()
        ? (dy < 0 ? 'up' : 'down')
        : (dx < 0 ? 'left' : 'right');

    HapticFeedback.lightImpact();
    widget.swipe(SwipeGesture(fingers: _s.swipeFingers, direction: direction));
    _s.resetSwipe();
  }

  @override
  void dispose() {
    _dragTimer?.cancel();
    super.dispose();
  }

  // ── build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,

      // ─── pointer down ────────────────────────
      onPointerDown: (e) {
        _s.fingers++;

        if (_s.fingers == 1) {
          _s.downTime = DateTime.now();
          _s.resetTap();

          _dragTimer?.cancel();
          _dragTimer = Timer(_dragDelay, () {
            if (_s.fingers == 1 &&
                !_s.isDragging &&
                _s.totalMove < _moveThreshold) {
              _startDrag();
            }
          });
        }

        if (_s.fingers == 2) {
          _s.twoFingerTap = true;
          _s.twoFingerMoved = false;
          _s.scrollAxis = null; // reset axis mỗi lần chạm mới
          _dragTimer?.cancel();
          if (_s.isDragging) _stopDrag();
        }

        if (_s.fingers == 3) {
          _s.isSwipeGesture = true;
          _s.swipeFingers = 3;
          _s.swipeDx = 0;
          _s.swipeDy = 0;
          _dragTimer?.cancel();
        }

        if (_s.fingers == 4) {
          _s.isSwipeGesture = true;
          _s.swipeFingers = 4;
          _s.swipeDx = 0;
          _s.swipeDy = 0;
        }
      },

      // ─── pointer move ────────────────────────
      onPointerMove: (e) {
        if (e.delta.distance < 0.5) return;

        // 3+ ngón → tích lũy delta để detect swipe khi nhấc
        if (_s.fingers >= 3 && _s.isSwipeGesture) {
          _s.swipeDx += e.delta.dx;
          _s.swipeDy += e.delta.dy;
          return;
        }

        // 2 ngón → scroll với axis lock
        if (_s.fingers == 2) {
          _handleScroll(e);
          return;
        }

        // 1 ngón → move / drag
        _s.totalMove += e.delta.distance;
        _s.didMove = true;

        if (_s.totalMove > _moveThreshold && !_s.isDragging) {
          _dragTimer?.cancel();
        }

        widget.moveMouse(MouseMove(dx: e.delta.dx, dy: -e.delta.dy));
      },

      // ─── pointer up ──────────────────────────
      onPointerUp: (e) {
        // fake UP của ngón drag → bỏ qua
        if (_s.isDragging && _s.fingers == 1) return;

        // 3+ ngón → detect swipe khi ngón cuối nhấc
        if (_s.fingers >= 3 && _s.isSwipeGesture) {
          _s.fingers = (_s.fingers - 1).clamp(0, 10);
          if (_s.fingers < 3) _detectSwipe();
          return;
        }

        _s.fingers = (_s.fingers - 1).clamp(0, 10);
        _dragTimer?.cancel();

        if (_s.fingers > 0) return;

        // ── tất cả ngón đã nhấc ──────────────────

        if (_s.isDragging) {
          _stopDrag();
          _s.lastTapTime = null;
          _s.resetScroll();
          return;
        }

        // 2 ngón tap nhanh không di chuyển → right click
        if (_s.twoFingerTap && !_s.twoFingerMoved) {
          final elapsed = _s.downTime == null
              ? const Duration(seconds: 1)
              : DateTime.now().difference(_s.downTime!);

          if (elapsed < _twoFingerWindow) {
            widget.rightClickMouse();
            _s.lastTapTime = null;
            _s.resetScroll();
            return;
          }
        }

        _s.resetScroll();

        // 1 ngón: click / double click
        if (!_s.didMove || _s.totalMove < _moveThreshold) {
          final last = _s.lastTapTime;
          if (last != null &&
              DateTime.now().difference(last) < _doubleTapWindow) {
            widget.doubleClickMouse();
            _s.lastTapTime = null;
          } else {
            widget.clickMouse();
            _s.lastTapTime = DateTime.now();
          }
        } else {
          // flush smoothing Mac
          widget.moveMouse(MouseMove(dx: 0, dy: 0));
          _s.lastTapTime = null;
        }

        _s.resetTap();
      },

      // ─── pointer cancel ──────────────────────
      onPointerCancel: (e) {
        // cancel của ngón drag → giữ nguyên, drag vẫn sống
        if (_s.isDragging && _s.fingers == 1) return;

        if (_s.fingers >= 3 && _s.isSwipeGesture) {
          _s.fingers = (_s.fingers - 1).clamp(0, 10);
          if (_s.fingers == 0) _s.resetSwipe();
          return;
        }

        _s.fingers = (_s.fingers - 1).clamp(0, 10);
        _dragTimer?.cancel();

        if (_s.fingers == 0) _s.resetScroll();
      },

      child: Container(width: double.infinity, height: double.infinity),
    );
  }
}
