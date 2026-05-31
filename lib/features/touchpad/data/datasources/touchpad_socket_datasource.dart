import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/socket_constants.dart';
import 'package:pc_remote/features/touchpad/domain/entities/scroll_delta.dart';
import 'package:pc_remote/features/touchpad/domain/entities/swipe_gesture.dart';

import '../../../../socket/client/socket_client.dart';

final touchpadSocketDatasourceProvider =
    Provider<TouchpadSocketDatasource>((ref) {
  final socketClient = ref.watch(socketClientProvider);
  return TouchpadSocketDatasource(socketClient);
});

class TouchpadSocketDatasource {
  final SocketClient socketClient;
  int _mouseMoveLogCount = 0;

  TouchpadSocketDatasource(this.socketClient);

  Future<void> moveMouse(double dx, double dy) async {
    _mouseMoveLogCount++;
    if (_mouseMoveLogCount <= 5 || _mouseMoveLogCount % 30 == 0) {
      log(
        'Emit mouse_move #$_mouseMoveLogCount dx: $dx, dy: $dy, connected: ${socketClient.isConnected}',
        name: 'TouchpadSocketDatasource',
      );
    }
    socketClient.emit(SocketConstants.eventMouseMove, {"dx": dx, "dy": dy});
  }

  Future<void> leftClick() async {
    socketClient.emit(SocketConstants.eventMouseLeftClick, {});
  }

  Future<void> rightClick() async {
    socketClient.emit(SocketConstants.eventMouseRightClick, {});
  }

  Future<void> doubleClick() async {
    socketClient.emit(SocketConstants.eventMouseDoubleClick, {});
  }

  Future<void> mouseDown() async {
    socketClient.emit(SocketConstants.eventMouseDown, {});
  }

  Future<void> mouseUp() async {
    socketClient.emit(SocketConstants.eventMouseUp, {});
  }

  Future<void> scroll(ScrollDelta delta) async {
    socketClient.emit(SocketConstants.eventMouseScroll, {
      "dx": delta.dx,
      "dy": delta.dy,
    });
  }

  Future<void> swipeGesture(SwipeGesture gesture) async {
    socketClient.emit(SocketConstants.eventSwipe, {
      "fingers": gesture.fingers,
      "direction": gesture.direction,
    });
  }
}

final remoteDatasourceProvider = Provider(
  (ref) => TouchpadSocketDatasource(ref.read(socketClientProvider)),
);
