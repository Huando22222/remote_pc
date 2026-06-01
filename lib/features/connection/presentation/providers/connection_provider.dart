import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_status.dart';
import 'package:pc_remote/socket/client/socket_client.dart';
import 'package:pc_remote/socket/handlers/device_socket_handler.dart';
import 'package:pc_remote/socket/handlers/file_socket_handler.dart';
import 'package:pc_remote/features/device/presentation/providers/remote_device_provider.dart';

import '../../domain/usecases/connect_usecase.dart';
import '../../domain/usecases/disconnect_usecase.dart';
import '../../domain/usecases/observe_connection_usecase.dart';

final connectionNotifierProvider =
    NotifierProvider<ConnectionNotifier, ConnectionStatus>(
  ConnectionNotifier.new,
);

class ConnectionNotifier extends Notifier<ConnectionStatus> {
  StreamSubscription<bool>? _subscription;
  bool _handlerRegistered = false;

  @override
  ConnectionStatus build() {
    final observe = ref.read(observeConnectionUseCaseProvider);

    _subscription?.cancel();

    _subscription = observe().listen((connected) {
      state = connected
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected;
    });

    ref.onDispose(() => _subscription?.cancel());

    return ConnectionStatus.disconnected;
  }

  Future<void> connect(String ip) async {
    if (state == ConnectionStatus.connecting) return;

    final socketClient = ref.read(socketClientProvider);
    ref.read(remoteDeviceProvider.notifier).clear();

    if (!_handlerRegistered) {
      _handlerRegistered = true;

      socketClient.onConnection((socket) {
        ref.read(deviceSocketHandlerProvider).register(socket);
        ref.read(fileSocketHandlerProvider).register(socket);
      });

      socketClient.onDisconnect((socket) {
        ref.read(deviceSocketHandlerProvider).dispose(socket);
        ref.read(remoteDeviceProvider.notifier).clear();
      });
    }

    state = ConnectionStatus.connecting;

    try {
      await ref.read(connectUseCaseProvider)(ip);
    } catch (_) {
      state = ConnectionStatus.disconnected;
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await ref.read(disconnectUseCaseProvider)();
    ref.read(remoteDeviceProvider.notifier).clear();

    state = ConnectionStatus.disconnected;
  }
}
