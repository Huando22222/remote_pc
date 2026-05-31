import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/keyboard/data/datasources/keyboard_socket_datasource.dart';
import 'package:pc_remote/features/keyboard/domain/repositories/keyboard_repository.dart';

final keyboardRepositoryProvider = Provider<KeyboardRepository>((ref) {
  return KeyboardRepositoryImpl(ref.read(keyboardSocketDatasourceProvider));
});

class KeyboardRepositoryImpl implements KeyboardRepository {
  KeyboardRepositoryImpl(this.datasource);

  final KeyboardSocketDatasource datasource;

  @override
  Future<void> sendText(String text) {
    return datasource.sendText(text);
  }

  @override
  Future<void> sendKey(String key) {
    return datasource.sendKey(key);
  }

  @override
  Future<void> sendShortcut(List<String> keys) {
    return datasource.sendShortcut(keys);
  }
}
