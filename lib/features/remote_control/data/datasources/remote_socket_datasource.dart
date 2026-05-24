import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/socket_constants.dart';
import 'package:pc_remote/features/remote_control/domain/entities/scroll_delta.dart';
import 'package:pc_remote/features/remote_control/domain/entities/swipe_gesture.dart';

import '../../../../socket/client/socket_client.dart';

final remoteSocketDatasourceProvider = Provider<RemoteSocketDatasource>((ref) {
  final socketClient = ref.watch(socketClientProvider);
  return RemoteSocketDatasource(socketClient);
});

class RemoteSocketDatasource {
  final SocketClient socketClient;

  RemoteSocketDatasource(this.socketClient);

  Future<void> moveMouse(double dx, double dy) async {
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
  (ref) => RemoteSocketDatasource(ref.read(socketClientProvider)),
);
