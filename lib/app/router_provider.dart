import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_remote/features/main/presentation/screens/main_shell_screen.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_provider.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_status.dart';
import 'package:pc_remote/features/file_transfer/presentation/screens/file_transfer_screen.dart';
import 'package:pc_remote/features/keyboard/presentation/screens/keyboard_screen.dart';
import 'package:pc_remote/features/settings/presentation/screens/settings_screen.dart';
import 'package:pc_remote/features/touchpad/presentation/screens/touchpad_screen.dart';

import '../core/config/routes.dart';
import '../features/connection/presentation/screens/connection_screen.dart';

class ConnectionRouterNotifier extends ChangeNotifier {
  ConnectionRouterNotifier(this._ref) {
    _ref.listen<ConnectionStatus>(
      connectionNotifierProvider,
      (previous, next) {
        if (previous != next) notifyListeners();
      },
    );
  }

  final Ref _ref;

  bool get isConnected =>
      _ref.read(connectionNotifierProvider) == ConnectionStatus.connected;
}

final connectionRouterNotifierProvider =
    Provider<ConnectionRouterNotifier>((ref) {
  return ConnectionRouterNotifier(ref);
});

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(connectionRouterNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.connection,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isConnected = notifier.isConnected;
      final onConnectionPage = state.matchedLocation == Routes.connection;

      // Connected on connection page -> enter the main remote surface.
      if (isConnected && onConnectionPage) return Routes.touchpad;

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.connection,
        builder: (context, state) => const ConnectionScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.touchpad,
            builder: (context, state) => const TouchpadScreen(),
          ),
          GoRoute(
            path: Routes.keyboard,
            builder: (context, state) => const KeyboardScreen(),
          ),
          GoRoute(
            path: Routes.fileTransfer,
            builder: (context, state) => const FileTransferScreen(),
          ),
          // Clipboard is hidden until the feature is ready for production use.
          // GoRoute(
          //   path: Routes.clipboard,
          //   builder: (context, state) => const ClipboardScreen(),
          // ),
          GoRoute(
            path: Routes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

