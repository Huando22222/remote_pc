abstract class KeyboardRepository {
  Future<void> sendText(String text);

  Future<void> sendKey(String key);

  Future<void> sendShortcut(List<String> keys);
}
