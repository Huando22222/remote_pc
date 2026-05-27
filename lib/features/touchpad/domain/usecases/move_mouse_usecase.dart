import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/data/repositories/touchpad_repository_impl.dart';

import '../repositories/touchpad_repository.dart';
import '../entities/mouse_move.dart';

class MoveMouseUseCase {
  final TouchpadRepository repository;

  MoveMouseUseCase(this.repository);

  Future<void> call(MouseMove move) {
    return repository.moveMouse(move);
  }
}

final moveMouseUseCaseProvider = Provider(
  (ref) => MoveMouseUseCase(ref.read(touchpadRepositoryProvider)),
);
