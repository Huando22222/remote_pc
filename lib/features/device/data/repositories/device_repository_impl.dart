import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_datasource.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => DeviceRepositoryImpl(ref.read(deviceDatasourceProvider)),
);

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDatasource _datasource;

  DeviceRepositoryImpl(
    this._datasource,
  );

  @override
  Future<String> getLocalIp() {
    return _datasource.getLocalIp();
  }

  @override
  Future<List<String>> getAllLocalIps() {
    return _datasource.getAllLocalIps();
  }

  @override
  Future<DeviceEntity> getDeviceInfo() {
    return _datasource.getDeviceInfo();
  }

  @override
  Future<void> sendClientDeviceInfo({required DeviceEntity device}) {
    return _datasource.sendClientDeviceInfo(device: device);
  }
}
