import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../socket/client/socket_client.dart';
import '../../../../socket/handlers/device_socket_handler.dart';
import '../../domain/usecases/connect_usecase.dart';
import '../../domain/usecases/disconnect_usecase.dart';
import '../../domain/usecases/observe_connection_usecase.dart';

final connectionNotifierProvider = NotifierProvider<ConnectionNotifier, bool>(
  ConnectionNotifier.new,
);

class ConnectionNotifier extends Notifier<bool> {
  StreamSubscription<bool>? _subscription;

  bool _registered = false;

  @override
  bool build() {
    final observe = ref.read(
      observeConnectionUseCaseProvider,
    );

    _subscription?.cancel();

    _subscription = observe().listen(
      (isConnected) {
        state = isConnected;
      },
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return false;
  }

  Future<void> connect(String ip) async {
    final socketClient = ref.read(socketClientProvider);

    // chỉ đăng ký 1 lần
    if (!_registered) {
      _registered = true;

      socketClient.onConnection(
        (socket) {
          ref
              .read(
                deviceSocketHandlerProvider,
              )
              .register(
                socket,
              );
        },
      );

      socketClient.onDisconnect(
        (socket) {
          ref
              .read(
                deviceSocketHandlerProvider,
              )
              .dispose(
                socket,
              );
        },
      );
    }

    final connectUseCase = ref.read(
      connectUseCaseProvider,
    );

    await connectUseCase(ip);
  }

  Future<void> disconnect() async {
    final disconnectUseCase = ref.read(
      disconnectUseCaseProvider,
    );

    await disconnectUseCase();
  }
}
