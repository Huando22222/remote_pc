import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/in_app_notification_helper.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/downloaded_files_provider.dart';
import '../providers/file_action_provider.dart';

Future<void> showDownloadedFilesSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => const DownloadedFilesSheet(),
  );
}

class DownloadedFilesSheet extends StatelessWidget {
  const DownloadedFilesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.65,
          child: const DownloadedFilesList(),
        ),
      ),
    );
  }
}

class DownloadedFilesList extends ConsumerWidget {
  const DownloadedFilesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(downloadedFilesProvider);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Downloaded files',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${files.length}',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: files.isEmpty
              ? Center(
                  child: Text(
                    'No downloaded files yet',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: files.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    return DownloadedFileTile(file: files[index]);
                  },
                ),
        ),
      ],
    );
  }
}

class DownloadedFileTile extends ConsumerWidget {
  const DownloadedFileTile({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final name = file.uri.pathSegments.last;

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.download_done_rounded,
          color: cs.primary,
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          file.path,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        trailing: PopupMenuButton<DownloadedFileAction>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (action) async {
            final box = context.findRenderObject() as RenderBox?;
            final origin = box == null
                ? null
                : box.localToGlobal(Offset.zero) & box.size;

            try {
              switch (action) {
                case DownloadedFileAction.open:
                  final result = await ref.read(fileActionProvider).open(file);
                  if (result.type.name != 'done') {
                    InAppNotificationHelper.warning(
                      context,
                      title: 'Cannot open file',
                      message: result.message,
                    );
                  }
                  break;
                case DownloadedFileAction.share:
                  await ref.read(fileActionProvider).share(
                        file,
                        sharePositionOrigin: origin,
                      );
                  InAppNotificationHelper.info(
                    context,
                    title: 'Share sheet opened',
                    message: 'Choose where to save or share the file.',
                  );
                  break;
              }
            } catch (e) {
              InAppNotificationHelper.error(
                context,
                title: 'File action failed',
                message: e.toString(),
              );
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: DownloadedFileAction.open,
              child: ListTile(
                leading: Icon(Icons.open_in_new_rounded),
                title: Text('Open'),
              ),
            ),
            PopupMenuItem(
              value: DownloadedFileAction.share,
              child: ListTile(
                leading: Icon(Icons.ios_share_rounded),
                title: Text('Save / Share'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum DownloadedFileAction {
  open,
  share,
}