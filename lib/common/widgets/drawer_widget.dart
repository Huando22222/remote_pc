import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_remote/core/config/routes.dart';
import 'package:pc_remote/core/localization/locale_provider.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_provider.dart';
import 'package:pc_remote/features/device/domain/entities/device_entity.dart';
import 'package:pc_remote/features/device/presentation/providers/device_provider.dart';
import 'package:pc_remote/features/device/presentation/providers/remote_device_provider.dart';
import 'package:pc_remote/features/settings/presentation/providers/app_settings_provider.dart';

import '../../../../core/theme/app_spacing.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final cn = ref.read(connectionNotifierProvider.notifier);
    final settingsNotifier = ref.read(appSettingsProvider.notifier);
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final svDv = ref.watch(deviceProvider);
    final rmtDv = ref.watch(remoteDeviceProvider);
    final strings = ref.watch(stringsProvider);

    return Drawer(
      backgroundColor: cs.surface,
      child: SafeArea(
        child: Column(
          spacing: AppSpacing.sm,
          children: [
            // _Header(
            //   serverDevice: rmtDv.first,
            //   remoteDevice: svDv,
            // ),
            svDv.when(
              data: (svDv) {
                if (rmtDv.isEmpty) {
                  return const SizedBox.shrink();
                }

                return _Header(
                  serverDevice: svDv,
                  remoteDevice: rmtDv.first,
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Column(
                  children: [
                    _DrawerItem(
                      onTap: () {
                        Navigator.pop(context);
                        context.go(Routes.touchpad);
                      },
                      icon: FontAwesomeIcons.handPointer,
                      label: strings.touchpad,
                      isActive: currentRoute == Routes.touchpad,
                    ),
                    _DrawerItem(
                      onTap: () {
                        Navigator.pop(context);
                        context.go(Routes.keyboard);
                      },
                      icon: FontAwesomeIcons.keyboard,
                      label: strings.keyboard,
                      isActive: currentRoute == Routes.keyboard,
                    ),
                    _DrawerItem(
                      onTap: () {
                        Navigator.pop(context);
                        context.go(Routes.fileTransfer);
                      },
                      icon: FontAwesomeIcons.fileArrowUp,
                      label: strings.fileTransfer,
                      isActive: currentRoute == Routes.fileTransfer,
                    ),
                    // Clipboard is hidden until the feature is ready for production use.
                    // _DrawerItem(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     context.go(Routes.clipboard);
                    //   },
                    //   icon: FontAwesomeIcons.clipboard,
                    //   label: strings.clipboard,
                    //   isActive: currentRoute == Routes.clipboard,
                    // ),
                    _DrawerItem(
                      onTap: () {
                        Navigator.pop(context);
                        context.go(Routes.settings);
                      },
                      icon: FontAwesomeIcons.gear,
                      label: strings.settings,
                      isActive: currentRoute == Routes.settings,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: _DrawerItem(
                onTap: () => _disconnect(context, cn, settingsNotifier),
                icon: FontAwesomeIcons.linkSlash,
                label: strings.disconnect,
                isDanger: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _disconnect(
    BuildContext context,
    ConnectionNotifier notifier,
    AppSettingsNotifier settingsNotifier,
  ) async {
    Scaffold.maybeOf(context)?.closeDrawer();
    await Future<void>.delayed(kThemeAnimationDuration);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    await settingsNotifier.setAutoConnect(false);
    await notifier.disconnect();
  }
}

class _Header extends StatelessWidget {
  final DeviceEntity serverDevice;
  final DeviceEntity remoteDevice;
  const _Header({
    required this.serverDevice,
    required this.remoteDevice,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              FontAwesomeIcons.desktop,
              size: 20,
              color: cs.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  remoteDevice.deviceName,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: cs.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        serverDevice.deviceName,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDanger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final color = isDanger
        ? cs.error
        : isActive
            ? cs.primary
            : cs.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      child: ListTile(
        selected: isActive,
        selectedTileColor: cs.primaryContainer.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
