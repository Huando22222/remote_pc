import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void register(io.Socket socket) {
    socket.on(
      SocketConstants.eventServerDeviceInfo,
      (data) {
        final device = DeviceModel.fromJson(
          Map<String, dynamic>.from(data),
        );

        ref.read(remoteDeviceProvider.notifier).add(device);
      },
    );
  }

  void dispose(io.Socket socket) {
    socket.off(SocketConstants.eventServerDeviceInfo);
  }
}
