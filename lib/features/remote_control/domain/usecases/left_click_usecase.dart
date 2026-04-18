import '../repositories/remote_repository.dart';

class LeftClickUseCase {
  final RemoteRepository repository;

  LeftClickUseCase(this.repository);

  Future<void> call() {
    return repository.leftClick();
  }
}
