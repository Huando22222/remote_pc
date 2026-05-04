import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? _socket;

  final _connectionController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream async* {
    // Emit trạng thái hiện tại trước
    yield _socket?.connected ?? false;

    // Sau đó forward các event mới
    yield* _connectionController.stream;
  }

  void connect(String ip) {
    print("CONNECTING TO: $ip");

    _socket = IO.io(
      "ws://$ip:2222",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableForceNew()
          .build(),
    );

    print("SOCKET CREATED");

    _socket!.onConnect((_) {
      print("SOCKET CONNECTED");
      _connectionController.add(true);
    });

    _socket!.onDisconnect((_) {
      print("SOCKET DISCONNECTED");
      _connectionController.add(false);
    });

    _socket!.onConnectError((e) {
      print("CONNECT ERROR: $e");
    });

    _socket!.onError((e) {
      print("SOCKET ERROR: $e");
    });

    _socket!.connect();

    print("CONNECT CALLED");
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
    _socket?.io.engine?.flush();
  }

  bool get isConnected => _socket?.connected ?? false;
}
