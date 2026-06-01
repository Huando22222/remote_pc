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
        if (previous == next) return;

        final shouldEnterRemoteSurface = next == ConnectionStatus.connected &&
            previous != ConnectionStatus.connected;
        final shouldReturnToConnection =
            next == ConnectionStatus.disconnected &&
                (previous == ConnectionStatus.connected ||
                    previous == ConnectionStatus.connecting);

        if (!shouldEnterRemoteSurface && !shouldReturnToConnection) return;

        FocusManager.instance.primaryFocus?.unfocus();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final navigatorContext = rootNavigatorKey.currentContext;
          if (navigatorContext == null) return;

          final router = GoRouter.of(navigatorContext);
          final currentLocation =
              router.routeInformationProvider.value.uri.path;

          if (shouldEnterRemoteSurface &&
              currentLocation == Routes.connection) {
            router.go(Routes.touchpad);
            return;
          }

          if (shouldReturnToConnection &&
              currentLocation != Routes.connection) {
            router.go(Routes.connection);
          }
        });
      },
    );

    return child;
  }
}
