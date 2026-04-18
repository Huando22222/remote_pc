import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_remote/features/remote_control/presentation/pages/remote_control_page.dart';

import '../core/config/routes.dart';
import '../features/connection/presentation/pages/connection_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.connection,
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
