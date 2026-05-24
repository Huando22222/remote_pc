import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/data/repositories/remote_repository_impl.dart';

import '../repositories/remote_repository.dart';

class DoubleClickUseCase {
  final RemoteRepository repository;

  DoubleClickUseCase(this.repository);

  Future<void> call() {
    return repository.doubleClick();
  }
}

final doubleClickUseCaseProvider = Provider(
  (ref) => DoubleClickUseCase(ref.read(remoteRepositoryProvider)),
);
