class DeviceEntity {
  final String deviceId;
  final String deviceName;
  final String platform;
  final String osVersion;
  final String localIp;
  final List<String> localIps;
  final DateTime lastSeen;
  const DeviceEntity({
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.osVersion,
    required this.localIp,
    required this.localIps,
    required this.lastSeen,
  });
}
