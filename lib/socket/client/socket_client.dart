import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/constants/socket_constants.dart';

final socketClientProvider = Provider((ref) {
  final client = SocketClient();

  ref.onDispose(client.dispose);

  return client;
});

class SocketClient {
  io.Socket? _socket;

  final _connectionController = StreamController<bool>.broadcast();

  io.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  Stream<bool> get connectionStream async* {
    yield _socket?.connected ?? false;
    yield* _connectionController.stream;
  }

  void connect(String ip) {
    if (_socket?.connected == true) return;

    _socket = io.io(
      'ws://$ip:${SocketConstants.port}',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableForceNew()
          .build(),
    );

    _socket!.onConnect((_) {
      _connectionController.add(true);
    });

    _socket!.onDisconnect((_) {
      _connectionController.add(false);
    });

    _socket!.connect();
  }

  void onConnection(
    void Function(io.Socket socket) callback,
  ) {
    _socket?.onConnect((_) {
      final socket = _socket;
      if (socket != null) {
        callback(socket);
      }
    });
  }

  void onDisconnect(
    void Function(io.Socket socket) callback,
  ) {
    _socket?.onDisconnect((_) {
      final socket = _socket;
      if (socket != null) {
        callback(socket);
      }
    });
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
    _socket?.io.engine.flush();
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void dispose() {
    _socket?.dispose();
    _connectionController.close();
  }
}
