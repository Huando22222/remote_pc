import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileTransferScreen extends ConsumerStatefulWidget {
  const FileTransferScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FIleTRansferSCreenState();
}

class _FIleTRansferSCreenState extends ConsumerState<FileTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'File Transfer Screen',
        style: TextStyle(fontSize: 24, color: Colors.red),
      ),
    );
  }
}
