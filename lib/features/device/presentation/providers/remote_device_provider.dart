import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/device_entity.dart';

final remoteDeviceProvider =
    NotifierProvider<RemoteDeviceNotifier, List<DeviceEntity>>(
  RemoteDeviceNotifier.new,
);

class RemoteDeviceNotifier extends Notifier<List<DeviceEntity>> {
  @override
  List<DeviceEntity> build() {
    return [];
  }

  void add(
    DeviceEntity device,
  ) {
    final exists = state.any(
      (e) => e.deviceId == device.deviceId,
    );

    if (exists) {
      state = [
        for (final item in state)
          if (item.deviceId == device.deviceId) device else item
      ];

      return;
    }

    state = [
      ...state,
      device,
    ];
  }

  void remove(
    String deviceId,
  ) {
    state = state
        .where(
          (e) => e.deviceId != deviceId,
        )
        .toList();
  }

  void clear() {
    state = [];
  }
}
