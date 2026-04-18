import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_remote/core/config/routes.dart';

import '../../../../di/providers.dart';

class ConnectionPage extends ConsumerStatefulWidget {
  const ConnectionPage({super.key});

  @override
  ConsumerState<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends ConsumerState<ConnectionPage> {
  final ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ipController.text = '172.16.10.106';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(connectionNotifierProvider, (prev, next) {
      if (next) {
        context.go(Routes.remote);
      }
    });

    final isConnected = ref.watch(connectionNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Socket Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "IP desktop",
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                ref
                    .read(connectionNotifierProvider.notifier)
                    .connect(ipController.text.trim());
              },
              child: Text(isConnected ? "Connected" : "Connect"),
            ),
          ],
        ),
      ),
    );
  }
}
