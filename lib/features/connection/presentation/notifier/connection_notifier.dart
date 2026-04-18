import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/di/providers.dart';

class ConnectionNotifier extends Notifier<bool> {
  StreamSubscription<bool>? _subscription;

  @override
  bool build() {
    final observe = ref.read(observeConnectionUseCaseProvider);

    _subscription?.cancel();

    _subscription = observe().listen((isConnected) {
      state = isConnected;
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return false;
  }

  Future<void> connect(String ip) async {
    final connectUseCase = ref.read(connectUseCaseProvider);
    await connectUseCase(ip);
  }

  Future<void> disconnect() async {
    final disconnectUseCase = ref.read(disconnectUseCaseProvider);
    await disconnectUseCase();
  }
}
