import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/device/presentation/providers/remote_device_provider.dart';
import 'package:pc_remote/features/file_transfer/data/datasources/file_upload_datasource.dart';
import 'package:pc_remote/features/file_transfer/domain/entities/selectable_file_entity.dart';

final selectedUploadFilesProvider =
    NotifierProvider<SelectedUploadFilesNotifier, List<SelectableFileEntity>>(
  SelectedUploadFilesNotifier.new,
);

final uploadingFilesProvider = NotifierProvider<UploadingFilesNotifier, bool>(
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

  List<File> get checkedFiles {
    return state.where((item) => item.checked).map((item) => item.file).toList();
  }
}

class UploadingFilesNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> uploadCheckedFiles() async {
    if (state) return;

    final remoteDevices = ref.read(remoteDeviceProvider);
    if (remoteDevices.isEmpty) {
      log('[UploadingFilesNotifier] no remote device connected');
      throw StateError('No PC connected');
    }

    final serverIp = remoteDevices.first.localIp;
    log(
      '[UploadingFilesNotifier] target serverIp=$serverIp '
      'remoteDevice=${remoteDevices.first.deviceName}',
    );

    final selected = ref.read(selectedUploadFilesProvider.notifier);
    final files = selected.checkedFiles;

    if (files.isEmpty) {
      log('[UploadingFilesNotifier] no checked files to upload');
      return;
    }

    log('[UploadingFilesNotifier] uploading ${files.length} file(s)');

    state = true;

    try {
      for (final file in files) {
        log('[UploadingFilesNotifier] uploading file path=${file.path}');
        await ref.read(fileUploadDatasourceProvider).upload(
              file: file,
              serverIp: serverIp,
            );
      }

      selected.clearChecked();
      log('[UploadingFilesNotifier] upload finished');
    } finally {
      state = false;
    }
  }
}