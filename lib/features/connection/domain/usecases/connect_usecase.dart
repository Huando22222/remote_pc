import '../repositories/connection_repository.dart';

class ConnectUseCase {
  final ConnectionRepository repository;

  ConnectUseCase(this.repository);

  Future<void> call(String ip) {
    return repository.connect(ip);
  }
}
