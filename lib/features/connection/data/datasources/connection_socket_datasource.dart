import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../socket/client/socket_client.dart';

class ConnectionSocketDatasource {
  final SocketClient socketClient;

  ConnectionSocketDatasource(this.socketClient);

  Future<void> connect(String ip) async {
    await socketClient.connect(ip);
  }

  Future<void> disconnect() async {
    socketClient.disconnect();
  }

  Stream<bool> observeConnection() {
    return socketClient.connectionStream;
  }
}

final connectionDatasourceProvider = Provider(
  (ref) => ConnectionSocketDatasource(ref.read(socketClientProvider)),
);
