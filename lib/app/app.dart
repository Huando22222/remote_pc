import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/localization/locale_provider.dart';
import 'package:pc_remote/core/theme/theme_provider.dart';
import 'package:pc_remote/features/file_transfer/presentation/widgets/incoming_files_listener.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../core/theme/app_theme.dart';
import 'router_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(localeProvider.notifier).loadSavedLocale();
      WakelockPlus.enable();
    });
  }

  @override
  Widget build(BuildContext context) {
    //! ⚠️ Không nên start server trong build (sẽ chạy nhiều lần)
    //ref.read(socketIoServerProvider).start();

    final router = ref.watch(routerProvider);
    final themeAsync = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: locale,
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeAsync.value ?? ThemeMode.dark,
      builder: (context, child) {
        return Builder(
          builder: (context) {
            return IncomingFilesListener(
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
