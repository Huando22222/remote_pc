import 'package:pc_remote/features/remote_control/domain/entities/swipe_gesture.dart';

import '../repositories/remote_repository.dart';

class SwipeUseCase {
  final RemoteRepository repository;

  SwipeUseCase(this.repository);

  Future<void> call(SwipeGesture gesture) {
    return repository.swipeGesture(gesture);
  }
}
