import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/socket_constants.dart';
import '../../../../core/extensions/device_ext.dart';
import '../../../../socket/client/socket_client.dart';
import '../../domain/entities/device_entity.dart';

final deviceSocketDatasourceProvider = Provider(
  (ref) => DeviceSocketDatasource(
    ref.read(socketClientProvider),
  ),
);

class DeviceSocketDatasource {
  final SocketClient socketClient;

  DeviceSocketDatasource(this.socketClient);

  Future<void> requestServerDeviceInfo() async {
    socketClient.emit(
      SocketConstants.eventRefreshDeviceInfo,
      {},
    );
  }

  Future<void> sendClientDeviceInfo(DeviceEntity device) async {
    socketClient.emit(
      SocketConstants.eventClientDeviceInfo,
      device.toJson(),
    );
  }
}
