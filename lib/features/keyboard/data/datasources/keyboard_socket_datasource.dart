import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/socket_constants.dart';
import 'package:pc_remote/socket/client/socket_client.dart';

final keyboardSocketDatasourceProvider =
    Provider<KeyboardSocketDatasource>((ref) {
  return KeyboardSocketDatasource(ref.read(socketClientProvider));
});

class KeyboardSocketDatasource {
  KeyboardSocketDatasource(this.socketClient);

  final SocketClient socketClient;

  Future<void> sendText(String text) async {
    socketClient.emit(SocketConstants.eventKeyboardText, {'text': text});
  }

  Future<void> sendKey(String key) async {
    socketClient.emit(SocketConstants.eventKeyboardKey, {'key': key});
  }

  Future<void> sendShortcut(List<String> keys) async {
    socketClient.emit(SocketConstants.eventKeyboardShortcut, {'keys': keys});
  }
}
