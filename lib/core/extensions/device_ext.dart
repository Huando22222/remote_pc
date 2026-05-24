import 'package:pc_remote/features/device/domain/entities/device_entity.dart';

extension DeviceExt on DeviceEntity {
  DeviceEntity copyWith({
    String? deviceName,
    String? platform,
    String? osVersion,
    String? localIp,
    List<String>? localIps,
    DateTime? lastSeen,
  }) {
    return DeviceEntity(
      deviceId: deviceId,
      deviceName: deviceName ?? this.deviceName,
      platform: platform ?? this.platform,
      osVersion: osVersion ?? this.osVersion,
      localIp: localIp ?? this.localIp,
      localIps: localIps ?? this.localIps,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
      'osVersion': osVersion,
      'localIp': localIp,
      'localIps': localIps,
    };
  }
}
