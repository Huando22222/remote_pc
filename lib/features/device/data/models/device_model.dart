import '../../domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.deviceId,
    required super.deviceName,
    required super.platform,
    required super.osVersion,
    required super.localIp,
    required super.localIps,
    required super.lastSeen,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      platform: json['platform'],
      osVersion: json['osVersion'],
      localIp: json['localIp'] ?? '0.0.0.0',
      localIps: List<String>.from(json['localIps'] ?? const []),
      lastSeen:
          DateTime.parse(json['lastSeen'] ?? DateTime.now().toIso8601String()),
    );
  }
}
