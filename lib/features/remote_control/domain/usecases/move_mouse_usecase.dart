import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/data/repositories/remote_repository_impl.dart';

import '../repositories/remote_repository.dart';
import '../entities/mouse_move.dart';

class MoveMouseUseCase {
  final RemoteRepository repository;

  MoveMouseUseCase(this.repository);

  Future<void> call(MouseMove move) {
    return repository.moveMouse(move);
  }
}

final moveMouseUseCaseProvider = Provider(
  (ref) => MoveMouseUseCase(ref.read(remoteRepositoryProvider)),
);
