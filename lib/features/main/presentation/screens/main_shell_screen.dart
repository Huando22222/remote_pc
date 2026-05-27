import 'package:flutter/material.dart';
import 'package:pc_remote/common/widgets/drawer_widget.dart';
import 'package:pc_remote/core/constants/app_constants.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: child,
    );
  }
}
