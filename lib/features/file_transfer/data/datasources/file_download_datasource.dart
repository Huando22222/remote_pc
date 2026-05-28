import 'dart:io';

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

    final savePath = '${dir.path}${Platform.pathSeparator}${file.name}';

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
}
