import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/connection/data/repositories/connection_repository_impl.dart';

import '../repositories/connection_repository.dart';

class ConnectUseCase {
  final ConnectionRepository repository;

  ConnectUseCase(this.repository);

  Future<void> call(String ip) {
    return repository.connect(ip);
  }
}

final connectUseCaseProvider = Provider(
  (ref) => ConnectUseCase(ref.read(connectionRepositoryProvider)),
);
