import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transfer_file_meta_entity.dart';

final incomingFilesProvider =
    NotifierProvider<IncomingFilesNotifier, List<TransferFileMetaEntity>>(
  IncomingFilesNotifier.new,
);

class IncomingFilesNotifier extends Notifier<List<TransferFileMetaEntity>> {
  @override
  List<TransferFileMetaEntity> build() => [];

  void addAll(List<TransferFileMetaEntity> files) {
    state = [...files, ...state];
  }

  void remove(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void clear() {
    state = [];
  }
}
