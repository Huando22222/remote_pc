import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_model.dart';

final deviceDatasourceProvider = Provider(
  (ref) => DeviceDatasource(),
);

class DeviceDatasource {
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceDatasource({
    DeviceInfoPlugin? deviceInfoPlugin,
  }) : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  Future<String> getLocalIp() async {
    final ips = await getAllLocalIps();

    if (ips.isEmpty) {
      return '0.0.0.0';
    }

    return ips.first;
  }

  Future<List<String>> getAllLocalIps() async {
    try {
      final result = <String>[];

      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );

      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          result.add(address.address);
        }
      }

      return result;
    } catch (_) {
      return [];
    }
  }

  Future<DeviceModel> getDeviceInfo() async {
    final localIps = await getAllLocalIps();
    final localIp = localIps.isEmpty ? '0.0.0.0' : localIps.first;

    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;

      return DeviceModel(
        deviceId: Platform.localHostname,
        deviceName: info.model,
        platform: Platform.operatingSystem,
        osVersion: info.version.release,
        localIp: localIp,
        localIps: localIps,
        lastSeen: DateTime.now(),
      );
    }

    if (Platform.isIOS) {
      final info = await _deviceInfoPlugin.iosInfo;

      return DeviceModel(
        deviceId: Platform.localHostname,
        deviceName: info.name,
        platform: Platform.operatingSystem,
        osVersion: info.systemVersion,
        localIp: localIp,
        localIps: localIps,
        lastSeen: DateTime.now(),
      );
    }

    return DeviceModel(
      deviceId: Platform.localHostname,
      deviceName: Platform.localHostname,
      platform: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      localIp: localIp,
      localIps: localIps,
      lastSeen: DateTime.now(),
    );
  }
}
