import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/constants/socket_constants.dart';
import '../../features/file_transfer/domain/entities/transfer_file_meta_entity.dart';
import '../../features/file_transfer/presentation/providers/incoming_files_provider.dart';

final fileSocketHandlerProvider = Provider(
  (ref) => FileSocketHandler(ref),
);

class FileSocketHandler {
  final Ref ref;

  FileSocketHandler(this.ref);

  void register(io.Socket socket) {
    socket.on(
      SocketConstants.eventFilesAvailable,
      (data) {
        log('Files available: $data');

        final list = data['files'] as List;

        final files = list
            .map(
              (e) => TransferFileMetaEntity.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();

        ref.read(incomingFilesProvider.notifier).addAll(files);
      },
    );
  }

  void dispose(io.Socket socket) {
    socket.off(SocketConstants.eventFilesAvailable);
  }
}
