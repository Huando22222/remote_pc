import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'touchpad_state.dart';
import '../../domain/entities/mouse_move.dart';
import '../../domain/entities/scroll_delta.dart';
import '../../domain/entities/swipe_gesture.dart';
import '../../domain/usecases/move_mouse_usecase.dart';
import '../../domain/usecases/left_click_usecase.dart';
import '../../domain/usecases/right_click_usecase.dart';
import '../../domain/usecases/double_click_usecase.dart';
import '../../domain/usecases/mouse_down_usecase.dart';
import '../../domain/usecases/mouse_up_usecase.dart';
import '../../domain/usecases/scroll_usecase.dart';
import '../../domain/usecases/swipe_usecase.dart';

// ── Ngưỡng ────────────────────────────────────────────────────────────────────
const _kMoveThreshold = 6.0; // px
const _kSwipeThreshold = 55.0; // px — tổng vector ≥ này → swipe
const _kLongPressMs = 500; // ms — giữ đủ lâu → mouseDown (bôi đen)
const _kTapMaxMs = 200; // ms — nhả trong thời gian này → tap hợp lệ
const _kDoubleTapMs = 280; // ms — window detect double-tap
const _kSingleTapDelayMs = 280; // ms — delay trước khi fire leftClick
//      (= _kDoubleTapMs, để không fire trước double-tap)
const _kScrollSensitivity = 1.0; // delta Flutter đã đủ lớn
const _kMoveSmoothAlpha = 0.4; // EMA alpha cho move: nhỏ=mượt, lớn=nhanh hơn
// ─────────────────────────────────────────────────────────────────────────────

class TouchpadWidget extends StatefulWidget {
  final MoveMouseUseCase moveMouse;
  final LeftClickUseCase leftClick;
  final RightClickUseCase rightClick;
  final DoubleClickUseCase doubleClick;
  final MouseDownUseCase mouseDown;
  final MouseUpUseCase mouseUp;
  final ScrollUseCase scroll;
  final SwipeUseCase swipe;
  final double mouseSensitivity;

  const TouchpadWidget({
    super.key,
    required this.moveMouse,
    required this.leftClick,
    required this.rightClick,
    required this.doubleClick,
    required this.mouseDown,
    required this.mouseUp,
    required this.scroll,
    required this.swipe,
    required this.mouseSensitivity,
  });

  @override
  State<TouchpadWidget> createState() => _TouchpadWidgetState();
}

class _TouchpadWidgetState extends State<TouchpadWidget> {
  final _s = TouchpadState();
  bool _mouseIsDown = false;

  // EMA smoothing cho move — giảm jitter delta nhỏ từ Flutter
  Offset _smoothDelta = Offset.zero;

  // Single-tap timer: chờ _kSingleTapDelayMs xem có tap 2 không
  // Nếu không có → fire leftClick. Nếu có tap 2 → cancel + doubleClick.
  Timer? _singleTapTimer;

  // ── mouse hold ────────────────────────────────────────────────────────────
  void _pressDown() {
    if (_mouseIsDown) return;
    log('mouseDown requested', name: 'TouchpadWidget');
    _mouseIsDown = true;
    widget.mouseDown();
  }

  void _releaseUp() {
    if (!_mouseIsDown) return;
    log('mouseUp requested', name: 'TouchpadWidget');
    _mouseIsDown = false;
    widget.mouseUp();
  }

  // ── EMA smooth move ───────────────────────────────────────────────────────
  // Exponential Moving Average: output[t] = alpha*input[t] + (1-alpha)*output[t-1]
  // Alpha nhỏ → mượt hơn nhưng hơi lag; alpha lớn → phản hồi nhanh hơn nhưng jittery
  Offset _smooth(Offset raw) {
    _smoothDelta = Offset(
      _kMoveSmoothAlpha * raw.dx + (1 - _kMoveSmoothAlpha) * _smoothDelta.dx,
      _kMoveSmoothAlpha * raw.dy + (1 - _kMoveSmoothAlpha) * _smoothDelta.dy,
    );
    return _smoothDelta;
  }

  void _resetSmooth() => _smoothDelta = Offset.zero;

  // ── direction helper ──────────────────────────────────────────────────────
  String _dir(Offset d) {
    if (d.dx.abs() >= d.dy.abs()) return d.dx > 0 ? 'right' : 'left';
    return d.dy > 0 ? 'down' : 'up';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // POINTER DOWN
  // ─────────────────────────────────────────────────────────────────────────
  void _onDown(PointerDownEvent e) {
    log(
      'onPointerDown pointer=${e.pointer}, position=${e.position}',
      name: 'TouchpadWidget',
    );
    _s.addPointer(e.pointer, e.position);

    switch (_s.fingerCount) {
      case 1:
        // Nếu singleTapTimer đang chờ (tap trước chưa fire leftClick)
        // và tap 2 xuống đủ nhanh → sẽ detect double-tap ở _onUp
        // → cancel timer ngay để không fire leftClick thừa
        _singleTapTimer?.cancel();
        _singleTapTimer = null;

        _resetSmooth();
        _s.phase = TouchpadPhase.tap1;
        _s.totalDelta = Offset.zero;
        _s.moveDistance = 0.0;
        _s.downTime = DateTime.now();

        _s.longPressTimer = Timer(
          const Duration(milliseconds: _kLongPressMs),
          _onLongPressTriggered,
        );
        break;

      case 2:
        if (_s.phase == TouchpadPhase.tap1 || _s.phase == TouchpadPhase.move) {
          _s.cancelLongPress();
          _releaseUp();
          _resetSmooth();
          _s.phase = TouchpadPhase.tap2;
          _s.totalDelta = Offset.zero;
          _s.moveDistance = 0.0;
          _s.downTime = DateTime.now();
        }
        break;

      default:
        _s.cancelLongPress();
        _releaseUp();
        _resetSmooth();
        _s.phase = TouchpadPhase.swipe;
        _s.totalDelta = Offset.zero;
        _s.moveDistance = 0.0;
        break;
    }
  }

  void _onLongPressTriggered() {
    log('onLongPressTriggered phase=${_s.phase}', name: 'TouchpadWidget');
    if (_s.phase != TouchpadPhase.tap1) return;
    _s.phase = TouchpadPhase.longPress;
    _pressDown();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // POINTER MOVE
  // ─────────────────────────────────────────────────────────────────────────
  void _onMove(PointerMoveEvent e) {
    log(
      'onPointerMove pointer=${e.pointer}, delta=${e.delta}, phase=${_s.phase}',
      name: 'TouchpadWidget',
    );
    if (!_s.hasPointer(e.pointer)) return;
    _s.updatePointer(e.pointer, e.position);

    final raw = e.delta;

    switch (_s.phase) {
      case TouchpadPhase.tap1:
        _s.totalDelta += raw;
        _s.moveDistance += raw.distance;
        if (_s.moveDistance > _kMoveThreshold) {
          _s.cancelLongPress();
          _s.phase = TouchpadPhase.move;
          final s = _smooth(raw);
          final move = MouseMove(
            dx: s.dx * widget.mouseSensitivity,
            dy: -s.dy * widget.mouseSensitivity,
          );
          log('moveMouse start dx=${move.dx}, dy=${move.dy}',
              name: 'TouchpadWidget');
          widget.moveMouse(move);
        }
        break;

      case TouchpadPhase.move:
        final s = _smooth(raw);
        final move = MouseMove(
          dx: s.dx * widget.mouseSensitivity,
          dy: -s.dy * widget.mouseSensitivity,
        );
        log('moveMouse dx=${move.dx}, dy=${move.dy}', name: 'TouchpadWidget');
        widget.moveMouse(move);
        break;

      case TouchpadPhase.longPress:
        _s.totalDelta += raw;
        _s.moveDistance += raw.distance;
        if (_s.moveDistance > _kMoveThreshold) {
          _s.phase = TouchpadPhase.drag;
          final s = _smooth(raw);
          final move = MouseMove(
            dx: s.dx * widget.mouseSensitivity,
            dy: -s.dy * widget.mouseSensitivity,
          );
          log('drag moveMouse start dx=${move.dx}, dy=${move.dy}',
              name: 'TouchpadWidget');
          widget.moveMouse(move);
        }
        break;

      case TouchpadPhase.drag:
        final s = _smooth(raw);
        final move = MouseMove(
          dx: s.dx * widget.mouseSensitivity,
          dy: -s.dy * widget.mouseSensitivity,
        );
        log('drag moveMouse dx=${move.dx}, dy=${move.dy}',
            name: 'TouchpadWidget');
        widget.moveMouse(move);
        break;

      case TouchpadPhase.tap2:
        _s.totalDelta += raw;
        _s.moveDistance += raw.distance;
        if (_s.moveDistance > _kMoveThreshold) {
          _s.phase = TouchpadPhase.scroll;
          _scroll(raw);
        }
        break;

      case TouchpadPhase.scroll:
        _scroll(raw);
        break;

      case TouchpadPhase.swipe:
        _s.totalDelta += raw;
        _s.moveDistance += raw.distance;
        break;

      case TouchpadPhase.idle:
        break;
    }
  }

  void _scroll(Offset d) {
    log('scroll dx=${-d.dx}, dy=${-d.dy}', name: 'TouchpadWidget');
    widget.scroll(
      ScrollDelta(
        dx: -d.dx * _kScrollSensitivity,
        dy: -d.dy * _kScrollSensitivity,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // POINTER UP
  // ─────────────────────────────────────────────────────────────────────────
  void _onUp(PointerUpEvent e) {
    log('onPointerUp pointer=${e.pointer}, phase=${_s.phase}',
        name: 'TouchpadWidget');
    _s.removePointer(e.pointer);
    if (_s.fingerCount > 0) return;

    final now = DateTime.now();
    final phase = _s.phase;
    final peak = _s.peakCount;
    final heldMs = _s.downTime != null
        ? now.difference(_s.downTime!).inMilliseconds
        : 9999;

    switch (phase) {
      case TouchpadPhase.tap1:
        _s.cancelLongPress();

        if (heldMs > _kTapMaxMs) {
          // Giữ gần đủ long-press nhưng nhả sớm → bỏ
          _s.resetAll();
          break;
        }

        final lastUp = _s.lastTapUp;
        if (lastUp != null &&
            now.difference(lastUp).inMilliseconds < _kDoubleTapMs) {
          // ── DOUBLE-TAP ──
          // singleTapTimer đã bị cancel ở _onDown case 1 rồi
          _s.resetAll();
          log('doubleClick requested', name: 'TouchpadWidget');
          widget.doubleClick();
        } else {
          // ── SINGLE TAP: chờ _kSingleTapDelayMs xem có tap 2 không ──
          _s.lastTapUp = now;
          _s.resetGesture(); // giữ lastTapUp

          _singleTapTimer = Timer(
            const Duration(milliseconds: _kSingleTapDelayMs),
            () {
              _singleTapTimer = null;
              _s.lastTapUp = null;
              log('leftClick requested', name: 'TouchpadWidget');
              widget.leftClick();
            },
          );
        }
        break;

      case TouchpadPhase.move:
        _resetSmooth();
        _s.resetAll();
        break;

      case TouchpadPhase.longPress:
        _releaseUp();
        _resetSmooth();
        _s.resetAll();
        break;

      case TouchpadPhase.drag:
        _releaseUp();
        _resetSmooth();
        _s.resetAll();
        break;

      case TouchpadPhase.tap2:
        if (heldMs <= _kTapMaxMs && peak == 2) {
          log('rightClick requested', name: 'TouchpadWidget');
          widget.rightClick();
        }
        _s.resetAll();
        break;

      case TouchpadPhase.scroll:
        _s.resetAll();
        break;

      case TouchpadPhase.swipe:
        if (_s.totalDelta.distance >= _kSwipeThreshold) {
          widget.swipe(
            SwipeGesture(fingers: peak, direction: _dir(_s.totalDelta)),
          );
          log(
            'swipe requested fingers=$peak, direction=${_dir(_s.totalDelta)}',
            name: 'TouchpadWidget',
          );
        }
        _s.resetAll();
        break;

      case TouchpadPhase.idle:
        _s.resetAll();
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // POINTER CANCEL
  // ─────────────────────────────────────────────────────────────────────────
  void _onCancel(PointerCancelEvent e) {
    log('onPointerCancel pointer=${e.pointer}', name: 'TouchpadWidget');
    _s.removePointer(e.pointer);
    if (_s.fingerCount == 0) {
      _releaseUp();
      _resetSmooth();
      _s.resetAll();
    }
  }

  @override
  void dispose() {
    _s.cancelLongPress();
    _singleTapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onDown,
      onPointerMove: _onMove,
      onPointerUp: _onUp,
      onPointerCancel: _onCancel,
      child: const SizedBox.expand(),
    );
  }
}
