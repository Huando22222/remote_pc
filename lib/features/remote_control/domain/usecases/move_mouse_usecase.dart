import '../repositories/remote_repository.dart';
import '../entities/mouse_move.dart';

class MoveMouseUseCase {
  final RemoteRepository repository;

  MoveMouseUseCase(this.repository);

  Future<void> call(MouseMove move) {
    return repository.moveMouse(move);
  }
}
