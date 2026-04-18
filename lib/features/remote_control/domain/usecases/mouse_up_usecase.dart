import '../repositories/remote_repository.dart';

class MouseUpUseCase {
  final RemoteRepository repository;

  MouseUpUseCase(this.repository);

  Future<void> call() {
    return repository.mouseUp();
  }
}
