import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/pref_constants.dart';
import 'package:pc_remote/core/providers/core_providers.dart';
import 'package:pc_remote/features/device/domain/entities/device_entity.dart';

class ConnectionHistoryEntry {
  const ConnectionHistoryEntry({
    required this.ip,
    required this.deviceName,
    required this.platform,
    required this.osVersion,
    required this.lastSeen,
  });

  final String ip;
  final String deviceName;
  final String platform;
  final String osVersion;
  final DateTime lastSeen;

  factory ConnectionHistoryEntry.fromJson(Map<String, dynamic> json) {
    return ConnectionHistoryEntry(
      ip: json['ip'] as String? ?? '',
      deviceName: json['deviceName'] as String? ?? 'Unknown PC',
      platform: json['platform'] as String? ?? '',
      osVersion: json['osVersion'] as String? ?? '',
      lastSeen: DateTime.tryParse(json['lastSeen'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'deviceName': deviceName,
      'platform': platform,
      'osVersion': osVersion,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }
}

final connectionHistoryProvider =
    NotifierProvider<ConnectionHistoryNotifier, List<ConnectionHistoryEntry>>(
  ConnectionHistoryNotifier.new,
);

class ConnectionHistoryNotifier extends Notifier<List<ConnectionHistoryEntry>> {
  @override
  List<ConnectionHistoryEntry> build() {
    final raw = ref.read(localStorageProvider).getString(
          PrefConstants.connectionHistory,
        );
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      final entries = decoded
          .whereType<Map>()
          .map((item) => ConnectionHistoryEntry.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .where((entry) => entry.ip.isNotEmpty)
          .toList();
      entries.sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
      return entries;
    } catch (_) {
      return [];
    }
  }

  Future<void> upsertIp(String ip, {DeviceEntity? device}) async {
    if (ip.isEmpty) return;

    final now = DateTime.now();
    final existing = state.where((item) => item.ip == ip).firstOrNull;
    final fallbackName = device?.deviceName ?? existing?.deviceName ?? 'PC $ip';
    final nextEntry = ConnectionHistoryEntry(
      ip: ip,
      deviceName: fallbackName,
      platform: device?.platform ?? existing?.platform ?? '',
      osVersion: device?.osVersion ?? existing?.osVersion ?? '',
      lastSeen: now,
    );

    final next = [
      nextEntry,
      for (final item in state)
        if (item.ip != ip) item,
    ];

    state = next.take(20).toList(growable: false);
    await _persist();
  }

  Future<void> updateDeviceInfo(DeviceEntity device, {String? connectedIp}) {
    final ip = _resolveIp(device, connectedIp);
    if (ip == null) return Future.value();
    return upsertIp(ip, device: device);
  }

  Future<void> removeIp(String ip) async {
    state = state.where((item) => item.ip != ip).toList(growable: false);
    await _persist();
  }

  Future<void> _persist() {
    final raw = jsonEncode(state.map((item) => item.toJson()).toList());
    return ref
        .read(localStorageProvider)
        .setString(PrefConstants.connectionHistory, raw);
  }

  String? _resolveIp(DeviceEntity device, String? connectedIp) {
    final ip = connectedIp?.trim();
    if (ip != null && ip.isNotEmpty) return ip;
    if (device.localIp.isNotEmpty && device.localIp != '0.0.0.0') {
      return device.localIp;
    }
    for (final item in device.localIps) {
      if (item.isNotEmpty && item != '0.0.0.0') return item;
    }
    return null;
  }
}
