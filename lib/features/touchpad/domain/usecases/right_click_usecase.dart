import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/data/repositories/touchpad_repository_impl.dart';
import 'package:pc_remote/features/touchpad/domain/repositories/touchpad_repository.dart';

class RightClickUseCase {
  final TouchpadRepository repository;

  RightClickUseCase(this.repository);

  Future<void> call() {
    return repository.rightClick();
  }
}

final rightClickUseCaseProvider = Provider(
  (ref) => RightClickUseCase(ref.read(touchpadRepositoryProvider)),
);
