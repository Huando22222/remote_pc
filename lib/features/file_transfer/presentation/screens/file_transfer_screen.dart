import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/swipe_widget.dart';
import '../../../../core/helpers/in_app_notification_helper.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/selectable_file_entity.dart';
import '../providers/downloaded_files_provider.dart';
import '../providers/incoming_files_provider.dart';
import '../providers/upload_files_provider.dart';
import '../widgets/downloaded_files_sheet.dart';

class FileTransferScreen extends ConsumerWidget {
  const FileTransferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadFiles = ref.watch(selectedUploadFilesProvider);
    final uploadState = ref.watch(uploadingFilesProvider);
    final incomingFiles = ref.watch(incomingFilesProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'File Transfer',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Send files to PC and receive files from PC.',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView(
              children: [
                _SendToPcSection(
                  files: uploadFiles,
                  uploadState: uploadState,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Text(
                      'Incoming files',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => showDownloadedFilesSheet(context),
                      icon: const Icon(Icons.download_done_rounded),
                      label: const Text('Downloaded'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (incomingFiles.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Center(
                      child: Text(
                        'No incoming files',
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  ...incomingFiles.map(
                    (file) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.insert_drive_file_rounded,
                            color: cs.primary,
                          ),
                          title: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${file.extension} - ${file.size} bytes',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.download_rounded),
                            onPressed: () async {
                              try {
                                await ref
                                    .read(downloadedFilesProvider.notifier)
                                    .downloadFile(file);
                                InAppNotificationHelper.success(
                                  context,
                                  title: 'File downloaded',
                                  message: file.name,
                                );
                              } catch (e) {
                                InAppNotificationHelper.error(
                                  context,
                                  title: 'Download failed',
                                  message: e.toString(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                const SizedBox(
                  height: 420,
                  child: DownloadedFilesList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SendToPcSection extends ConsumerWidget {
  const _SendToPcSection({
    required this.files,
    required this.uploadState,
  });

  final List<SelectableFileEntity> files;
  final UploadingFilesState uploadState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hasChecked = files.any((file) => file.checked == true);
    final uploading = uploadState.uploading;
    final strings = ref.watch(stringsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Send to PC',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: uploading
                  ? null
                  : () => ref
                      .read(selectedUploadFilesProvider.notifier)
                      .pickFiles(),
              icon: const Icon(Icons.attach_file_rounded),
              label: const Text('Choose'),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton.icon(
              onPressed: !hasChecked || uploading
                  ? null
                  : () async {
                      try {
                        await ref
                            .read(uploadingFilesProvider.notifier)
                            .uploadCheckedFiles();

                        InAppNotificationHelper.success(
                          context,
                          title: 'Files sent',
                          message: 'Selected files were sent to PC.',
                        );
                      } on MissingUploadFilesException catch (e) {
                        final fileNames = e.fileNames.join(', ');
                        InAppNotificationHelper.error(
                          context,
                          title: strings.selectedFileMissingTitle,
                          message: e.fileNames.length == 1
                              ? strings.selectedFileMissingMessage(fileNames)
                              : strings.selectedFilesMissingMessage(fileNames),
                        );
                      } catch (e) {
                        InAppNotificationHelper.error(
                          context,
                          title: 'Send failed',
                          message: e.toString(),
                        );
                      }
                    },
              icon: uploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_rounded),
              label: Text(uploading ? 'Sending' : 'Send'),
            ),
          ],
        ),
        if (uploading) ...[
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(value: uploadState.progress),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Sending file ${uploadState.currentFile}/${uploadState.totalFiles} '
            '- ${(uploadState.progress * 100).toStringAsFixed(0)}%',
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        if (files.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Text(
              'Choose files from this phone to send to PC.',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          )
        else
          ...files.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SwipeWidget(
                borderRadius: AppSpacing.radiusMd,
                actions: [
                  SwipeAction(
                    icon: Icons.delete_outline_rounded,
                    label: strings.remove,
                    onTap: () {
                      ref
                          .read(selectedUploadFilesProvider.notifier)
                          .remove(item.id);
                    },
                    backgroundColor: cs.error,
                    foregroundColor: cs.onError,
                  ),
                ],
                child: _UploadFileTile(item: item),
              ),
            ),
          ),
      ],
    );
  }
}

class _UploadFileTile extends ConsumerWidget {
  const _UploadFileTile({required this.item});

  final SelectableFileEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = item.file;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final strings = ref.watch(stringsProvider);
    final name = file.uri.pathSegments.last;

    return FutureBuilder<_UploadFileStatus>(
      future: _readStatus(file),
      builder: (context, snapshot) {
        final status = snapshot.data;
        final missing = status?.missing ?? false;
        final size = status?.size;

        return Card(
          child: CheckboxListTile(
            value: item.checked,
            onChanged: (_) {
              ref.read(selectedUploadFilesProvider.notifier).toggle(item.id);
            },
            secondary: Icon(
              missing
                  ? Icons.error_outline_rounded
                  : Icons.insert_drive_file_rounded,
              color: missing ? cs.error : cs.primary,
            ),
            title: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              missing
                  ? strings.fileUnavailableDescription
                  : size == null
                      ? file.path
                      : '${_formatSize(size)} - ${file.path}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: missing
                  ? tt.bodySmall?.copyWith(color: cs.error)
                  : tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      },
    );
  }

  Future<_UploadFileStatus> _readStatus(File file) async {
    try {
      if (!await file.exists()) {
        return const _UploadFileStatus(missing: true);
      }

      return _UploadFileStatus(size: await file.length());
    } on FileSystemException {
      return const _UploadFileStatus(missing: true);
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }
}

class _UploadFileStatus {
  const _UploadFileStatus({
    this.size,
    this.missing = false,
  });

  final int? size;
  final bool missing;
}
