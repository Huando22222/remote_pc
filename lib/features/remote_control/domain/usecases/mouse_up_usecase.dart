import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/data/repositories/remote_repository_impl.dart';

import '../repositories/remote_repository.dart';

class MouseUpUseCase {
  final RemoteRepository repository;

  MouseUpUseCase(this.repository);

  Future<void> call() {
    return repository.mouseUp();
  }
}

final mouseUpUseCaseProvider = Provider(
  (ref) => MouseUpUseCase(ref.read(remoteRepositoryProvider)),
);
