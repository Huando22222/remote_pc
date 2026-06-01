import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

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

  Future<void> connect(String ip) async {
    if (_socket?.connected == true) return;

    final completer = Completer<void>();

    _socket?.dispose();
    _socket = io.io(
      'ws://$ip:${ApiConstants.socketPort}',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .disableReconnection()
          .enableForceNew()
          .build(),
    );

    _socket!.onConnect((_) {
      if (!completer.isCompleted) completer.complete();
      _connectionController.add(true);

      final socket = _socket;
      if (socket != null) {
        _onConnected?.call(socket);
      }
    });

    _socket!.onDisconnect((_) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Unable to connect to PC'));
      }
      _connectionController.add(false);

      final socket = _socket;
      if (socket != null) {
        _onDisconnected?.call(socket);
      }
    });

    _socket!.onConnectError((error) {
      if (!completer.isCompleted) {
        completer.completeError(Exception(error.toString()));
      }
    });

    _socket!.onError((error) {
      if (!completer.isCompleted) {
        completer.completeError(Exception(error.toString()));
      }
    });

    _socket!.connect();

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        _socket?.disconnect();
        throw TimeoutException('Connection timeout');
      },
    );
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

  bool emit(String event, dynamic data) {
    try {
      if (_socket?.connected != true) {
        log('Skip emit $event because socket is not connected');
        return false;
      }

      _socket?.emit(event, data);
      _socket?.io.engine.flush();
      return true;
    } catch (error, stackTrace) {
      log(
        'Socket emit failed: $event',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  void disconnect() {
    final socket = _socket;
    _socket = null;
    socket?.disconnect();
    socket?.dispose();
    _connectionController.add(false);
  }

  void dispose() {
    _socket?.dispose();
    _connectionController.close();
  }
}
