import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

final fileActionProvider = Provider(
  (ref) => FileActionService(),
);

class FileActionService {
  Future<OpenResult> open(File file) {
    return OpenFilex.open(file.path);
  }

  Future<ShareResult> share(
    File file, {
    Rect? sharePositionOrigin,
  }) {
    return SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: file.uri.pathSegments.last,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}
