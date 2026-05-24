import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/device/data/repositories/device_repository_impl.dart';

import '../repositories/device_repository.dart';

class GetLocalIpUseCase {
  final DeviceRepository repository;

  GetLocalIpUseCase(this.repository);

  Future<String> call() {
    return repository.getLocalIp();
  }
}

final getLocalIpUseCaseProvider = Provider(
  (ref) => GetLocalIpUseCase(
    ref.read(deviceRepositoryProvider),
  ),
);
