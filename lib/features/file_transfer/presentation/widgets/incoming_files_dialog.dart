import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/transfer_file_meta_entity.dart';

class IncomingFilesDialog extends StatelessWidget {
  const IncomingFilesDialog({
    super.key,
    required this.files,
    required this.onAccept,
    required this.onReject,
  });

  final List<TransferFileMetaEntity> files;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AlertDialog(
      title: const Text('Nhận file từ PC?'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PC muốn gửi ${files.length} file sang thiết bị này.',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: files.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final file = files[index];

                  return ListTile(
                    dense: true,
                    leading: Icon(
                      _iconForFile(file.name),
                      color: cs.primary,
                    ),
                    title: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${_formatSize(file.size)} • ${file.extension}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onReject,
          child: const Text('Từ chối'),
        ),
        FilledButton.icon(
          onPressed: onAccept,
          icon: const Icon(Icons.download_rounded),
          label: const Text('Nhận file'),
        ),
      ],
    );
  }

  IconData _iconForFile(String name) {
    final lower = name.toLowerCase();

    if (lower.endsWith('.pdf')) return Icons.picture_as_pdf_rounded;
    if (lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp')) {
      return Icons.image_rounded;
    }
    if (lower.endsWith('.mp4') || lower.endsWith('.mov')) {
      return Icons.video_file_rounded;
    }
    if (lower.endsWith('.zip') || lower.endsWith('.rar')) {
      return Icons.folder_zip_rounded;
    }

    return Icons.insert_drive_file_rounded;
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }
}
