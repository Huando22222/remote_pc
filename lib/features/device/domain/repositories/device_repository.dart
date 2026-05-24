import '../entities/device_entity.dart';

abstract class DeviceRepository {
  Future<String> getLocalIp();

  Future<List<String>> getAllLocalIps();

  Future<DeviceEntity> getDeviceInfo();
}
