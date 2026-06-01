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
    final textBase64 = base64Encode(utf8.encode(text));
    final payload = jsonEncode({
      'encoding': 'utf8.base64',
      'textBase64': textBase64,
    });
    log(
      'emit keyboard_text text="$text", length=${text.length}, runes=${text.runes.length}, codePoints=${_codePoints(text)}, base64=$textBase64, payload=$payload',
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

  String _codePoints(String text) {
    return text.runes
        .map((value) => 'U+${value.toRadixString(16).toUpperCase()}')
        .join(' ');
  }
}
