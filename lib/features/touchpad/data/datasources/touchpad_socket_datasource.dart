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

  TouchpadSocketDatasource(this.socketClient);

  Future<void> moveMouse(double dx, double dy) async {
    log(
      'emit mouse_move dx=$dx, dy=$dy, connected=${socketClient.isConnected}',
      name: 'TouchpadSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventMouseMove, {"dx": dx, "dy": dy});
  }

  Future<void> leftClick() async {
    log(
      'emit mouse_left_click connected=${socketClient.isConnected}',
      name: 'TouchpadSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventMouseLeftClick, {});
  }

  Future<void> rightClick() async {
    log(
      'emit mouse_right_click connected=${socketClient.isConnected}',
      name: 'TouchpadSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventMouseRightClick, {});
  }

  Future<void> doubleClick() async {
    log(
      'emit mouse_double_click connected=${socketClient.isConnected}',
      name: 'TouchpadSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventMouseDoubleClick, {});
  }

  Future<void> mouseDown() async {
    log(
      'emit mouse_down connected=${socketClient.isConnected}',
      name: 'TouchpadSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventMouseDown, {});
  }

  Future<void> mouseUp() async {
    log(
      'emit mouse_up connected=${socketClient.isConnected}',
      name: 'TouchpadSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventMouseUp, {});
  }

  Future<void> scroll(ScrollDelta delta) async {
    log(
      'emit mouse_scroll dx=${delta.dx}, dy=${delta.dy}, connected=${socketClient.isConnected}',
      name: 'TouchpadSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventMouseScroll, {
      "dx": delta.dx,
      "dy": delta.dy,
    });
  }

  Future<void> swipeGesture(SwipeGesture gesture) async {
    log(
      'emit swipe fingers=${gesture.fingers}, direction=${gesture.direction}, connected=${socketClient.isConnected}',
      name: 'TouchpadSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventSwipe, {
      "fingers": gesture.fingers,
      "direction": gesture.direction,
    });
  }
}

final remoteDatasourceProvider = Provider(
  (ref) => TouchpadSocketDatasource(ref.read(socketClientProvider)),
);
