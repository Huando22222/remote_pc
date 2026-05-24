import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/connection/data/repositories/connection_repository_impl.dart';

import '../repositories/connection_repository.dart';

class DisconnectUseCase {
  final ConnectionRepository repository;

  DisconnectUseCase(this.repository);

  Future<void> call() {
    return repository.disconnect();
  }
}

final disconnectUseCaseProvider = Provider(
  (ref) => DisconnectUseCase(ref.read(connectionRepositoryProvider)),
);
