import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/extensions/device_ext.dart';

import '../../domain/entities/device_entity.dart';
import '../../domain/usecases/get_all_local_ips_usecase.dart';
import '../../domain/usecases/get_device_info_usecase.dart';

final deviceProvider =
    AsyncNotifierProvider<DeviceNotifier, DeviceEntity>(DeviceNotifier.new);

class DeviceNotifier extends AsyncNotifier<DeviceEntity> {
  @override
  Future<DeviceEntity> build() {
    return ref.read(getDeviceInfoUseCaseProvider)();
  }

  Future<void> refreshDeviceInfo() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(getDeviceInfoUseCaseProvider)(),
    );
  }

  Future<void> refreshIpOnly() async {
    final current = state.asData?.value;

    if (current == null) {
      await refreshDeviceInfo();
      return;
    }

    final ips = await ref.read(getAllLocalIpsUseCaseProvider)();
    final ip = ips.isEmpty ? '0.0.0.0' : ips.first;

    state = AsyncData(
      current.copyWith(
        localIp: ip,
        localIps: ips,
      ),
    );
  }
}
