import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/app_links.dart';
import 'package:pc_remote/core/localization/locale_provider.dart';
import 'package:pc_remote/core/theme/app_spacing.dart';
import 'package:pc_remote/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final locale = ref.watch(localeProvider);
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final localeNotifier = ref.read(localeProvider.notifier);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ListView(
      padding: AppSpacing.paddingLg,
      children: [
        Text(
          strings.settings,
          style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(strings.mouseSensitivity, style: tt.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          strings.mouseSensitivityDescription,
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: 0.4,
                max: 3.0,
                divisions: 26,
                value: settings.mouseSensitivity,
                label: '${settings.mouseSensitivity.toStringAsFixed(1)}x',
                onChanged: notifier.setMouseSensitivity,
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                '${settings.mouseSensitivity.toStringAsFixed(1)}x',
                textAlign: TextAlign.end,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: notifier.resetMouseSensitivity,
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(strings.reset),
          ),
        ),
        const Divider(height: AppSpacing.xl),
        Text(strings.scrollSensitivity, style: tt.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          strings.scrollSensitivityDescription,
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: 0.2,
                max: 2.0,
                divisions: 18,
                value: settings.scrollSensitivity,
                label: '${settings.scrollSensitivity.toStringAsFixed(1)}x',
                onChanged: notifier.setScrollSensitivity,
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                '${settings.scrollSensitivity.toStringAsFixed(1)}x',
                textAlign: TextAlign.end,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: notifier.resetScrollSensitivity,
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(strings.reset),
          ),
        ),
        const Divider(height: AppSpacing.xl),
        SwitchListTile(
          value: settings.autoConnect,
          onChanged: notifier.setAutoConnect,
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.link_rounded),
          title: Text(strings.autoConnect),
          subtitle: Text(strings.autoConnectDescription),
        ),
        const Divider(height: AppSpacing.xl),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.desktop_windows_rounded),
          title: Text(strings.desktopAppDownload),
          subtitle: Text(strings.desktopAppDownloadDescription),
          trailing: const Icon(Icons.open_in_new_rounded),
          onTap: () => _openDesktopDownloadLink(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: _openDesktopDownloadLink,
            icon: const Icon(Icons.download_rounded),
            label: Text(strings.openDownloadLink),
          ),
        ),
        const Divider(height: AppSpacing.xl),
        Text(strings.language, style: tt.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(
              value: 'vi',
              icon: const Icon(Icons.language_rounded),
              label: Text(strings.vietnamese),
            ),
            ButtonSegment(
              value: 'en',
              icon: const Icon(Icons.translate_rounded),
              label: Text(strings.english),
            ),
          ],
          selected: {locale.languageCode},
          onSelectionChanged: (selection) {
            localeNotifier.changeLocale(Locale(selection.first));
          },
        ),
      ],
    );
  }

  Future<void> _openDesktopDownloadLink() async {
    final uri = Uri.parse(AppLinks.desktopServerDownload);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
