import 'dart:async';
import '../protocol/socket_message.dart';

class SocketEventBus {
  final _controller = StreamController<SocketMessage>.broadcast();

  void emit(SocketMessage message) {
    _controller.add(message);
  }

  Stream<SocketMessage> on(String type) {
    return _controller.stream.where((event) => event.type == type);
  }
}
