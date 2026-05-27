import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/data/repositories/touchpad_repository_impl.dart';

import '../repositories/touchpad_repository.dart';

class MouseUpUseCase {
  final TouchpadRepository repository;

  MouseUpUseCase(this.repository);

  Future<void> call() {
    return repository.mouseUp();
  }
}

final mouseUpUseCaseProvider = Provider(
  (ref) => MouseUpUseCase(ref.read(touchpadRepositoryProvider)),
);
