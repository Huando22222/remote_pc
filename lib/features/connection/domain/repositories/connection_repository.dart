abstract class ConnectionRepository {
  Future<void> connect(String ip);
  Future<void> disconnect();
  Stream<bool> observeConnection();
}
