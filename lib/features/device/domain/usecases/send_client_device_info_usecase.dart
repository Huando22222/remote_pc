import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/device/data/repositories/device_repository_impl.dart';
import 'package:pc_remote/features/device/domain/entities/device_entity.dart';
import 'package:pc_remote/features/device/domain/repositories/device_repository.dart';

class SendClientDeviceInfoUsecase {
  final DeviceRepository repository;

  SendClientDeviceInfoUsecase(this.repository);

  Future<void> call({required DeviceEntity device}) {
    return repository.sendClientDeviceInfo(device: device);
  }
}

final sendClientDeviceInfoUsecaseProvider = Provider(
  (ref) => SendClientDeviceInfoUsecase(ref.read(deviceRepositoryProvider)),
);
