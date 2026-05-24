import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/data/repositories/remote_repository_impl.dart';

import '../repositories/remote_repository.dart';

class MouseDownUseCase {
  final RemoteRepository repository;

  MouseDownUseCase(this.repository);

  Future<void> call() {
    return repository.mouseDown();
  }
}

final mouseDownUseCaseProvider = Provider(
  (ref) => MouseDownUseCase(ref.read(remoteRepositoryProvider)),
);
