import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/data/repositories/touchpad_repository_impl.dart';
import '../repositories/touchpad_repository.dart';

class LeftClickUseCase {
  final TouchpadRepository repository;

  LeftClickUseCase(this.repository);

  Future<void> call() {
    return repository.leftClick();
  }
}

final leftClickUseCaseProvider = Provider(
  (ref) => LeftClickUseCase(ref.read(touchpadRepositoryProvider)),
);
