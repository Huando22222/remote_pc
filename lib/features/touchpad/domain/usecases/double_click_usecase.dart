import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/data/repositories/touchpad_repository_impl.dart';

import '../repositories/touchpad_repository.dart';

class DoubleClickUseCase {
  final TouchpadRepository repository;

  DoubleClickUseCase(this.repository);

  Future<void> call() {
    return repository.doubleClick();
  }
}

final doubleClickUseCaseProvider = Provider(
  (ref) => DoubleClickUseCase(ref.read(touchpadRepositoryProvider)),
);
