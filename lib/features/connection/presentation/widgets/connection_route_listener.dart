import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_remote/app/router_provider.dart';
import 'package:pc_remote/core/config/routes.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_provider.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_status.dart';

class ConnectionRouteListener extends ConsumerWidget {
  const ConnectionRouteListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ConnectionStatus>(
      connectionNotifierProvider,
      (previous, next) {
        final wasConnected = previous == ConnectionStatus.connected ||
            previous == ConnectionStatus.connecting;
        final isDisconnected = next == ConnectionStatus.disconnected;

        if (!wasConnected || !isDisconnected) return;

        FocusManager.instance.primaryFocus?.unfocus();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final navigatorContext = rootNavigatorKey.currentContext;
          if (navigatorContext == null) return;

          final router = GoRouter.of(navigatorContext);
          final currentLocation =
              router.routeInformationProvider.value.uri.path;

          if (currentLocation == Routes.connection) return;

          router.go(Routes.connection);
        });
      },
    );

    return child;
  }
}
