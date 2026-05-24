import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/data/repositories/remote_repository_impl.dart';
import 'package:pc_remote/features/remote_control/domain/repositories/remote_repository.dart';

class RightClickUseCase {
  final RemoteRepository repository;

  RightClickUseCase(this.repository);

  Future<void> call() {
    return repository.rightClick();
  }
}

final rightClickUseCaseProvider = Provider(
  (ref) => RightClickUseCase(ref.read(remoteRepositoryProvider)),
);
