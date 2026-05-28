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
  }) async {
    final name = file.uri.pathSegments.last;
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
            Headers.contentLengthHeader: size,
          },
          contentType: 'application/octet-stream',
        ),
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
}