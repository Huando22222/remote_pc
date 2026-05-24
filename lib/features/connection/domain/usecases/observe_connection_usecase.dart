import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/connection/data/repositories/connection_repository_impl.dart';

import '../repositories/connection_repository.dart';

class ObserveConnectionUseCase {
  final ConnectionRepository repository;

  ObserveConnectionUseCase(this.repository);

  Stream<bool> call() {
    return repository.observeConnection();
  }
}

final observeConnectionUseCaseProvider = Provider(
  (ref) => ObserveConnectionUseCase(ref.read(connectionRepositoryProvider)),
);
