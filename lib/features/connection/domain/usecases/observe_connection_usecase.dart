import '../repositories/connection_repository.dart';

class ObserveConnectionUseCase {
  final ConnectionRepository repository;

  ObserveConnectionUseCase(this.repository);

  Stream<bool> call() {
    return repository.observeConnection();
  }
}
