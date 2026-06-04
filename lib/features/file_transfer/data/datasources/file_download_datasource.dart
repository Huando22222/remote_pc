import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/transfer_file_meta_entity.dart';

final fileDownloadDatasourceProvider = Provider(
  (ref) => FileDownloadDatasource(),
);

class FileDownloadDatasource {
  final Dio _dio = Dio();

  Future<File> download(
    TransferFileMetaEntity file,
  ) async {
    final dir = await _downloadDir();

    final fileName = _safeFileName(file.name);
    final savePath = '${dir.path}${Platform.pathSeparator}$fileName';

    log(
      '[FileDownloadDatasource] download name=${file.name} safeName=$fileName url=${file.downloadUrl}',
    );

    await _dio.download(
      file.downloadUrl,
      savePath,
    );

    return File(savePath);
  }

  Future<Directory> _downloadDir() async {
    final base = await getApplicationDocumentsDirectory();

    final dir = Directory(
      '${base.path}${Platform.pathSeparator}PCRemote${Platform.pathSeparator}Downloads',
    );

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir;
  }

  String _safeFileName(String name) {
    final sanitized = name.replaceAll('\\', '_').replaceAll('/', '_').trim();
    return sanitized.isEmpty ? 'file.bin' : sanitized;
  }
}
