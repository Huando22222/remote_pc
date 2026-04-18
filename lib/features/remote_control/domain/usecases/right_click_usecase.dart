import 'package:pc_remote/features/remote_control/domain/repositories/remote_repository.dart';

class RightClickUseCase {
  final RemoteRepository repository;

  RightClickUseCase(this.repository);

  Future<void> call() {
    return repository.rightClick();
  }
}
