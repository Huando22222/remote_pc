import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClipboardScreen extends ConsumerStatefulWidget {
  const ClipboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClipboardScreenState();
}

class _ClipboardScreenState extends ConsumerState<ClipboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Clipboard Screen',
        style: TextStyle(fontSize: 24, color: Colors.red),
      ),
    );
  }
}
