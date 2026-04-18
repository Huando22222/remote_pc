import 'package:pc_remote/features/remote_control/domain/entities/scroll_delta.dart';
import 'package:pc_remote/features/remote_control/domain/entities/swipe_gesture.dart';

import '../entities/mouse_move.dart';

abstract class RemoteRepository {
  /// Move cursor
  Future<void> moveMouse(MouseMove move);

  /// Left click
  Future<void> leftClick();

  /// Right click
  Future<void> rightClick();

  /// Double click
  Future<void> doubleClick();

  /// Drag start
  Future<void> mouseDown();

  /// Drag end
  Future<void> mouseUp();

  /// Scroll
  Future<void> scroll(ScrollDelta delta);

  /// Three finger swipe
  /// direction: "up", "down", "left", "right"
  Future<void> swipeGesture(SwipeGesture gesture);
}
