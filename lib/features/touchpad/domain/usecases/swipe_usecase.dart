import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/data/repositories/touchpad_repository_impl.dart';
import 'package:pc_remote/features/touchpad/domain/entities/swipe_gesture.dart';

import '../repositories/touchpad_repository.dart';

class SwipeUseCase {
  final TouchpadRepository repository;

  SwipeUseCase(this.repository);

  Future<void> call(SwipeGesture gesture) {
    return repository.swipeGesture(gesture);
  }
}

final swipeUseCaseProvider = Provider(
  (ref) => SwipeUseCase(ref.read(touchpadRepositoryProvider)),
);
