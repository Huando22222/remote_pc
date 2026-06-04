import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/api_constants.dart';

final fileUploadDatasourceProvider = Provider(
  (ref) => FileUploadDatasource(),
);

class FileUploadRejectedException implements Exception {
  const FileUploadRejectedException();

  @override
  String toString() => 'PC rejected the file transfer';
}

class FileUploadSaveLocationMissingException implements Exception {
  const FileUploadSaveLocationMissingException();

  @override
  String toString() => 'PC did not choose a save folder';
}

class FileUploadDatasource {
  final Dio _dio = Dio();

  Future<void> upload({
    required File file,
    required String serverIp,
    required String batchId,
    required int fileIndex,
    required int totalFiles,
    void Function(int sent, int total)? onProgress,
  }) async {
    final name = _fileNameOf(file);
    final size = await file.length();
    final url = 'http://$serverIp:${ApiConstants.httpPort}/upload';

    log('[FileUploadDatasource] POST $url name=$name size=$size path=${file.path}');

    try {
      final response = await _dio.post(
        url,
        data: file.openRead(),
        options: Options(
          headers: {
            'x-file-name': Uri.encodeComponent(name),
            'x-file-name-base64': base64Encode(utf8.encode(name)),
            'x-upload-batch-id': batchId,
            'x-upload-file-index': fileIndex,
            'x-upload-total-files': totalFiles,
            Headers.contentLengthHeader: size,
          },
          contentType: 'application/octet-stream',
        ),
        onSendProgress: onProgress,
      );

      log('[FileUploadDatasource] upload completed status=${response.statusCode} name=$name');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == HttpStatus.forbidden) {
        log('[FileUploadDatasource] upload rejected by PC name=$name status=403');
        throw const FileUploadRejectedException();
      }

      if (statusCode == HttpStatus.conflict) {
        log('[FileUploadDatasource] upload cancelled because PC did not choose save folder name=$name status=409');
        throw const FileUploadSaveLocationMissingException();
      }

      log('[FileUploadDatasource] upload failed name=$name status=$statusCode error=$e');
      rethrow;
    }
  }

  String _fileNameOf(File file) {
    final normalizedPath = file.path.replaceAll('\\', '/');
    final parts = normalizedPath
        .split('/')
        .where((part) => part.trim().isNotEmpty)
        .toList();
    return parts.isEmpty ? 'file.bin' : parts.last;
  }
}
