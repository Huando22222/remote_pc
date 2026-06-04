import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/device/presentation/providers/remote_device_provider.dart';
import 'package:pc_remote/features/file_transfer/data/datasources/file_upload_datasource.dart';
import 'package:pc_remote/features/file_transfer/domain/entities/selectable_file_entity.dart';
import 'package:pc_remote/features/settings/presentation/providers/app_settings_provider.dart';

final selectedUploadFilesProvider =
    NotifierProvider<SelectedUploadFilesNotifier, List<SelectableFileEntity>>(
  SelectedUploadFilesNotifier.new,
);

class UploadingFilesState {
  const UploadingFilesState({
    required this.uploading,
    required this.currentFile,
    required this.totalFiles,
    required this.sentBytes,
    required this.totalBytes,
  });

  const UploadingFilesState.idle()
      : uploading = false,
        currentFile = 0,
        totalFiles = 0,
        sentBytes = 0,
        totalBytes = 0;

  final bool uploading;
  final int currentFile;
  final int totalFiles;
  final int sentBytes;
  final int totalBytes;

  double get progress {
    if (totalBytes <= 0) return 0;
    return (sentBytes / totalBytes).clamp(0, 1);
  }

  UploadingFilesState copyWith({
    bool? uploading,
    int? currentFile,
    int? totalFiles,
    int? sentBytes,
    int? totalBytes,
  }) {
    return UploadingFilesState(
      uploading: uploading ?? this.uploading,
      currentFile: currentFile ?? this.currentFile,
      totalFiles: totalFiles ?? this.totalFiles,
      sentBytes: sentBytes ?? this.sentBytes,
      totalBytes: totalBytes ?? this.totalBytes,
    );
  }
}

class MissingUploadFilesException implements Exception {
  const MissingUploadFilesException(this.fileNames);

  final List<String> fileNames;

  @override
  String toString() {
    if (fileNames.length == 1) {
      return 'File is no longer available on this device: ${fileNames.first}';
    }

    return 'Some files are no longer available on this device: ${fileNames.join(', ')}';
  }
}

final uploadingFilesProvider =
    NotifierProvider<UploadingFilesNotifier, UploadingFilesState>(
  UploadingFilesNotifier.new,
);

class SelectedUploadFilesNotifier extends Notifier<List<SelectableFileEntity>> {
  @override
  List<SelectableFileEntity> build() => [];

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
    );

    if (result == null) return;

    final files = result.files
        .where((file) => file.path != null)
        .map((file) => File(file.path!))
        .toList();

    log('[SelectedUploadFilesNotifier] picked ${files.length} file(s)');
    addFiles(files);
  }

  void addFiles(List<File> files) {
    final items = files.map(
      (file) => SelectableFileEntity(
        id: '${DateTime.now().microsecondsSinceEpoch}-${file.path.hashCode}',
        file: file,
        checked: true,
      ),
    );

    state = [...state, ...items];
  }

  void toggle(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(checked: !item.checked) else item,
    ];
  }

  void remove(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearChecked() {
    state = state.where((item) => !item.checked).toList();
  }

  List<SelectableFileEntity> get checkedItems {
    return state.where((item) => item.checked).toList();
  }

  List<File> get checkedFiles {
    return checkedItems.map((item) => item.file).toList();
  }
}

class UploadingFilesNotifier extends Notifier<UploadingFilesState> {
  @override
  UploadingFilesState build() => const UploadingFilesState.idle();

  Future<void> uploadCheckedFiles() async {
    if (state.uploading) return;

    final remoteDevices = ref.read(remoteDeviceProvider);
    if (remoteDevices.isEmpty) {
      log('[UploadingFilesNotifier] no remote device connected');
      throw StateError('No PC connected');
    }

    final serverIp = ref.read(appSettingsProvider).lastConnectedIp ??
        remoteDevices.first.localIp;
    log(
      '[UploadingFilesNotifier] target serverIp=$serverIp '
      'remoteDevice=${remoteDevices.first.deviceName}',
    );

    final selected = ref.read(selectedUploadFilesProvider.notifier);
    final checkedItems = selected.checkedItems;
    final files = checkedItems.map((item) => item.file).toList();

    if (files.isEmpty) {
      log('[UploadingFilesNotifier] no checked files to upload');
      return;
    }

    final fileSizes = <File, int>{};
    final missingItems = <SelectableFileEntity>[];
    var totalBytes = 0;
    for (final item in checkedItems) {
      final file = item.file;
      try {
        if (!await file.exists()) {
          missingItems.add(item);
          continue;
        }

        final size = await file.length();
        fileSizes[file] = size;
        totalBytes += size;
      } on FileSystemException {
        missingItems.add(item);
      }
    }

    if (missingItems.isNotEmpty) {
      for (final item in missingItems) {
        selected.remove(item.id);
      }

      final names = missingItems
          .map((item) => item.file.uri.pathSegments.last)
          .where((name) => name.isNotEmpty)
          .toList();
      log('[UploadingFilesNotifier] missing selected files names=$names');
      throw MissingUploadFilesException(names);
    }

    final batchId = DateTime.now().microsecondsSinceEpoch.toString();

    log(
      '[UploadingFilesNotifier] uploading ${files.length} file(s) batchId=$batchId totalBytes=$totalBytes',
    );

    state = UploadingFilesState(
      uploading: true,
      currentFile: 0,
      totalFiles: files.length,
      sentBytes: 0,
      totalBytes: totalBytes,
    );

    try {
      var completedBytes = 0;
      for (var index = 0; index < files.length; index++) {
        final file = files[index];
        log('[UploadingFilesNotifier] uploading file path=${file.path}');
        state = state.copyWith(currentFile: index + 1);
        await ref.read(fileUploadDatasourceProvider).upload(
              file: file,
              serverIp: serverIp,
              batchId: batchId,
              fileIndex: index,
              totalFiles: files.length,
              onProgress: (sent, _) {
                state = state.copyWith(sentBytes: completedBytes + sent);
              },
            );
        completedBytes += fileSizes[file] ?? 0;
        state = state.copyWith(sentBytes: completedBytes);
      }

      selected.clearChecked();
      log('[UploadingFilesNotifier] upload finished');
    } finally {
      state = const UploadingFilesState.idle();
    }
  }
}
