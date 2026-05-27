import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/domain/entities/scroll_delta.dart';
import 'package:pc_remote/features/touchpad/domain/entities/swipe_gesture.dart';

import '../../domain/entities/mouse_move.dart';
import '../../domain/repositories/touchpad_repository.dart';
import '../datasources/touchpad_socket_datasource.dart';

class TouchpadRepositoryImpl implements TouchpadRepository {
  final TouchpadSocketDatasource datasource;

  TouchpadRepositoryImpl(this.datasource);

  @override
  Future<void> moveMouse(MouseMove move) {
    return datasource.moveMouse(move.dx, move.dy);
  }

  @override
  Future<void> doubleClick() {
    return datasource.doubleClick();
  }

  @override
  Future<void> leftClick() {
    return datasource.leftClick();
  }

  @override
  Future<void> mouseDown() {
    return datasource.mouseDown();
  }

  @override
  Future<void> mouseUp() {
    return datasource.mouseUp();
  }

  @override
  Future<void> rightClick() {
    return datasource.rightClick();
  }

  @override
  Future<void> scroll(ScrollDelta delta) {
    return datasource.scroll(delta);
  }

  @override
  Future<void> swipeGesture(SwipeGesture gesture) {
    return datasource.swipeGesture(gesture);
  }
}

final touchpadRepositoryProvider = Provider(
  (ref) => TouchpadRepositoryImpl(ref.read(remoteDatasourceProvider)),
);
