import '../repositories/remote_repository.dart';

class DoubleClickUseCase {
  final RemoteRepository repository;

  DoubleClickUseCase(this.repository);

  Future<void> call() {
    return repository.doubleClick();
  }
}
