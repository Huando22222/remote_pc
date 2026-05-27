import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/data/repositories/touchpad_repository_impl.dart';
import 'package:pc_remote/features/touchpad/domain/entities/scroll_delta.dart';

import '../repositories/touchpad_repository.dart';

class ScrollUseCase {
  final TouchpadRepository repository;

  ScrollUseCase(this.repository);

  Future<void> call(ScrollDelta delta) {
    return repository.scroll(delta);
  }
}

final scrollUseCaseProvider = Provider(
  (ref) => ScrollUseCase(ref.read(touchpadRepositoryProvider)),
);
