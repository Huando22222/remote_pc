import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/device/domain/usecases/send_client_device_info_usecase.dart';
import 'package:pc_remote/features/device/presentation/providers/device_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/constants/socket_constants.dart';
import '../../features/device/data/models/device_model.dart';
import '../../features/device/presentation/providers/remote_device_provider.dart';

final deviceSocketHandlerProvider = Provider(
  (ref) => DeviceSocketHandler(ref),
);

class DeviceSocketHandler {
  final Ref ref;

  DeviceSocketHandler(this.ref);

  void register(io.Socket socket) async {
    log('Registering device socket handlers');
    socket.on(
      SocketConstants.eventRefreshDeviceInfo,
      (data) async {
        log('Received device info: $data');
        final device = DeviceModel.fromJson(
          Map<String, dynamic>.from(data),
        );

        ref.read(remoteDeviceProvider.notifier).add(device);
        final clientDevice = await ref.read(deviceProvider.future);
        ref
            .read(sendClientDeviceInfoUsecaseProvider)
            .call(device: clientDevice);
      },
    );
  }

  void dispose(io.Socket socket) {
    socket.off(SocketConstants.eventServerDeviceInfo);
  }
}
