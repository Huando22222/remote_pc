import '../repositories/remote_repository.dart';

class MouseDownUseCase {
  final RemoteRepository repository;

  MouseDownUseCase(this.repository);

  Future<void> call() {
    return repository.mouseDown();
  }
}
