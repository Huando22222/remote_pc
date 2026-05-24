import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/data/repositories/remote_repository_impl.dart';
import '../repositories/remote_repository.dart';

class LeftClickUseCase {
  final RemoteRepository repository;

  LeftClickUseCase(this.repository);

  Future<void> call() {
    return repository.leftClick();
  }
}

final leftClickUseCaseProvider = Provider(
  (ref) => LeftClickUseCase(ref.read(remoteRepositoryProvider)),
);
