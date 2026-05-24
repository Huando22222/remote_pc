import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/domain/entities/scroll_delta.dart';
import 'package:pc_remote/features/remote_control/domain/entities/swipe_gesture.dart';

import '../../domain/entities/mouse_move.dart';
import '../../domain/repositories/remote_repository.dart';
import '../datasources/remote_socket_datasource.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteSocketDatasource datasource;

  RemoteRepositoryImpl(this.datasource);

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

final remoteRepositoryProvider = Provider(
  (ref) => RemoteRepositoryImpl(ref.read(remoteDatasourceProvider)),
);
