import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/common/widgets/drawer_widget.dart';
import 'package:pc_remote/core/localization/locale_provider.dart';

class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(strings.appName),
      ),
      body: child,
    );
  }
}
