import 'dart:developer';

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
    log(
      'repository moveMouse dx=${move.dx}, dy=${move.dy}',
      name: 'TouchpadRepositoryImpl',
    );
    return datasource.moveMouse(move.dx, move.dy);
  }

  @override
  Future<void> doubleClick() {
    log('repository doubleClick', name: 'TouchpadRepositoryImpl');
    return datasource.doubleClick();
  }

  @override
  Future<void> leftClick() {
    log('repository leftClick', name: 'TouchpadRepositoryImpl');
    return datasource.leftClick();
  }

  @override
  Future<void> mouseDown() {
    log('repository mouseDown', name: 'TouchpadRepositoryImpl');
    return datasource.mouseDown();
  }

  @override
  Future<void> mouseUp() {
    log('repository mouseUp', name: 'TouchpadRepositoryImpl');
    return datasource.mouseUp();
  }

  @override
  Future<void> rightClick() {
    log('repository rightClick', name: 'TouchpadRepositoryImpl');
    return datasource.rightClick();
  }

  @override
  Future<void> scroll(ScrollDelta delta) {
    log(
      'repository scroll dx=${delta.dx}, dy=${delta.dy}',
      name: 'TouchpadRepositoryImpl',
    );
    return datasource.scroll(delta);
  }

  @override
  Future<void> swipeGesture(SwipeGesture gesture) {
    log(
      'repository swipe fingers=${gesture.fingers}, direction=${gesture.direction}',
      name: 'TouchpadRepositoryImpl',
    );
    return datasource.swipeGesture(gesture);
  }
}

final touchpadRepositoryProvider = Provider(
  (ref) => TouchpadRepositoryImpl(ref.read(remoteDatasourceProvider)),
);
