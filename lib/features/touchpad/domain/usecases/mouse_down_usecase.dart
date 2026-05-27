import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/data/repositories/touchpad_repository_impl.dart';

import '../repositories/touchpad_repository.dart';

class MouseDownUseCase {
  final TouchpadRepository repository;

  MouseDownUseCase(this.repository);

  Future<void> call() {
    return repository.mouseDown();
  }
}

final mouseDownUseCaseProvider = Provider(
  (ref) => MouseDownUseCase(ref.read(touchpadRepositoryProvider)),
);
