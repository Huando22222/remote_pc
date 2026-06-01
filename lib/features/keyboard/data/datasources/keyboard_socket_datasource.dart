import 'dart:async';
import 'dart:convert';
import 'dart:developer';

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
    final payload = jsonEncode({'text': text});
    log(
      'emit keyboard_text "$text", length=${text.length}, runes=${text.runes.length}',
      name: 'KeyboardSocketDatasource',
    );
    socketClient.emit(SocketConstants.eventKeyboardText, payload);
  }

  Future<void> sendKey(String key) async {
    log('emit keyboard_key $key', name: 'KeyboardSocketDatasource');
    socketClient.emit(SocketConstants.eventKeyboardKey, {'key': key});
  }

  Future<void> sendShortcut(List<String> keys) async {
    log('emit keyboard_shortcut ${keys.join('+')}',
        name: 'KeyboardSocketDatasource');
    socketClient.emit(SocketConstants.eventKeyboardShortcut, {'keys': keys});
  }
}
