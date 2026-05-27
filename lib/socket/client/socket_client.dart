import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/api_constants.dart';
import 'package:pc_remote/socket/handlers/device_socket_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/constants/socket_constants.dart';

final socketClientProvider = Provider((ref) {
  final client = SocketClient();

  ref.onDispose(client.dispose);

  return client;
});

class SocketClient {
  io.Socket? _socket;
  void Function(io.Socket socket)? _onConnected;
  void Function(io.Socket socket)? _onDisconnected;
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
      'ws://$ip:${ApiConstants.socketPort}',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableForceNew()
          .build(),
    );

    _socket!.onConnect((_) {
      _connectionController.add(true);

      final socket = _socket;
      if (socket != null) {
        _onConnected?.call(socket);
      }
    });

    _socket!.onDisconnect((_) {
      _connectionController.add(false);

      final socket = _socket;
      if (socket != null) {
        _onDisconnected?.call(socket);
      }
    });

    _socket!.connect();
  }

  void onConnection(
    void Function(io.Socket socket) callback,
  ) {
    _onConnected = callback;
  }

  void onDisconnect(
    void Function(io.Socket socket) callback,
  ) {
    _onDisconnected = callback;
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
