import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_remote/di/providers.dart';
import 'package:pc_remote/features/remote_control/presentation/pages/remote_control_page.dart';

import '../core/config/routes.dart';
import '../features/connection/presentation/pages/connection_page.dart';

// ─────────────────────────────────────────────
// ConnectionRouterNotifier
// Lắng nghe connectionNotifierProvider,
// notify GoRouter mỗi khi trạng thái thay đổi
// ─────────────────────────────────────────────

class ConnectionRouterNotifier extends ChangeNotifier {
  ConnectionRouterNotifier(this._ref) {
    _ref.listen<bool>(
      connectionNotifierProvider,
      (previous, next) {
        if (previous != next) notifyListeners();
      },
    );
  }

  final Ref _ref;

  bool get isConnected => _ref.read(connectionNotifierProvider);
}

final connectionRouterNotifierProvider =
    Provider<ConnectionRouterNotifier>((ref) {
  return ConnectionRouterNotifier(ref);
});

// ─────────────────────────────────────────────
// Router
// ─────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(connectionRouterNotifierProvider);

  return GoRouter(
    initialLocation: Routes.connection,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isConnected = notifier.isConnected;
      final onConnectionPage = state.matchedLocation == Routes.connection;

      // Mất kết nối → về màn hình connection
      if (!isConnected && !onConnectionPage) return Routes.connection;

      // Đã kết nối mà đang ở connection page → vào remote
      if (isConnected && onConnectionPage) return Routes.remote;

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.connection,
        builder: (context, state) => const ConnectionPage(),
      ),
      GoRoute(
        path: Routes.remote,
        builder: (context, state) => const RemoteControlPage(),
      ),
    ],
  );
});
