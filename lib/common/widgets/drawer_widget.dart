import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_spacing.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    this.deviceName = 'Huân PC',
  });

  final String deviceName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: cs.surface,
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(deviceName: deviceName),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                children: const [
                  _DrawerItem(
                    icon: FontAwesomeIcons.handPointer,
                    label: 'Touchpad',
                    isActive: true,
                  ),
                  _DrawerItem(
                    icon: FontAwesomeIcons.keyboard,
                    label: 'Keyboard',
                  ),
                  _DrawerItem(
                    icon: FontAwesomeIcons.fileArrowUp,
                    label: 'Send file',
                  ),
                  _DrawerItem(
                    icon: FontAwesomeIcons.clipboard,
                    label: 'Clipboard',
                  ),
                  _DrawerItem(
                    icon: FontAwesomeIcons.volumeHigh,
                    label: 'Media control',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: _DrawerItem(
                icon: FontAwesomeIcons.linkSlash,
                label: 'Disconnect',
                isDanger: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.deviceName,
  });

  final String deviceName;

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
            child: FaIcon(
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
                  'PC Remote',
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
                        deviceName,
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
    this.isActive = false,
    this.isDanger = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final iconColor = isDanger
        ? cs.error
        : isActive
            ? cs.primary
            : cs.onSurfaceVariant;

    final textColor = isDanger
        ? cs.error
        : isActive
            ? cs.primary
            : cs.onSurface;

    final bgColor = isActive ? cs.primaryContainer.withOpacity(0.55) : null;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: ListTile(
        dense: true,
        minLeadingWidth: 24,
        horizontalTitleGap: 12,
        leading: FaIcon(icon, size: 17, color: iconColor),
        title: Text(
          label,
          style: tt.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
