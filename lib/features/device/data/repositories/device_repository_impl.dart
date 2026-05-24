import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_datasource.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => DeviceRepositoryImpl(ref.read(deviceDatasourceProvider)),
);

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDatasource datasource;

  DeviceRepositoryImpl(this.datasource);

  @override
  Future<String> getLocalIp() {
    return datasource.getLocalIp();
  }

  @override
  Future<List<String>> getAllLocalIps() {
    return datasource.getAllLocalIps();
  }

  @override
  Future<DeviceEntity> getDeviceInfo() {
    return datasource.getDeviceInfo();
  }
}
