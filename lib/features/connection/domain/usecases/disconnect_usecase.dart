import '../repositories/connection_repository.dart';

class DisconnectUseCase {
  final ConnectionRepository repository;

  DisconnectUseCase(this.repository);

  Future<void> call() {
    return repository.disconnect();
  }
}
