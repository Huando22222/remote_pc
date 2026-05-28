import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/pref_constants.dart';
import 'package:pc_remote/core/providers/core_providers.dart';

import '../../data/datasources/file_download_datasource.dart';
import '../../domain/entities/transfer_file_meta_entity.dart';

final downloadedFilesProvider =
    NotifierProvider<DownloadedFilesNotifier, List<File>>(
  DownloadedFilesNotifier.new,
);

class DownloadedFilesNotifier extends Notifier<List<File>> {
  @override
  List<File> build() {
    final paths = ref.read(sharedPrefsProvider).getStringList(
          PrefConstants.downloadedFilePaths,
        ) ??
        const [];

    return paths.map(File.new).where((file) => file.existsSync()).toList();
  }

  Future<void> downloadFile(
    TransferFileMetaEntity file,
  ) async {
    final saved = await ref.read(fileDownloadDatasourceProvider).download(file);

    state = [
      saved,
      ...state.where((item) => item.path != saved.path),
    ];

    await _persist();
  }

  Future<void> downloadAll(
    List<TransferFileMetaEntity> files,
  ) async {
    for (final file in files) {
      await downloadFile(file);
    }
  }

  Future<void> removeMissingFiles() async {
    state = state.where((file) => file.existsSync()).toList();
    await _persist();
  }

  Future<void> _persist() {
    return ref.read(sharedPrefsProvider).setStringList(
          PrefConstants.downloadedFilePaths,
          state.map((file) => file.path).toList(),
        );
  }
}