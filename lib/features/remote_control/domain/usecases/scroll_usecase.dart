import 'package:pc_remote/features/remote_control/domain/entities/scroll_delta.dart';

import '../repositories/remote_repository.dart';

class ScrollUseCase {
  final RemoteRepository repository;

  ScrollUseCase(this.repository);

  Future<void> call(ScrollDelta delta) {
    return repository.scroll(delta);
  }
}
