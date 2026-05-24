import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/device/data/repositories/device_repository_impl.dart';
import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class GetDeviceInfoUseCase {
  final DeviceRepository repository;

  GetDeviceInfoUseCase(this.repository);

  Future<DeviceEntity> call() {
    return repository.getDeviceInfo();
  }
}

final getDeviceInfoUseCaseProvider = Provider(
  (ref) => GetDeviceInfoUseCase(
    ref.read(deviceRepositoryProvider),
  ),
);
