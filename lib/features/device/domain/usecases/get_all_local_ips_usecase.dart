import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/device/data/repositories/device_repository_impl.dart';
import '../repositories/device_repository.dart';

class GetAllLocalIpsUseCase {
  final DeviceRepository repository;

  GetAllLocalIpsUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getAllLocalIps();
  }
}

final getAllLocalIpsUseCaseProvider = Provider(
  (ref) => GetAllLocalIpsUseCase(
    ref.read(deviceRepositoryProvider),
  ),
);
