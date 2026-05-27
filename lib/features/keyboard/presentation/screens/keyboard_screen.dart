import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyboardScreen extends ConsumerStatefulWidget {
  const KeyboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends ConsumerState<KeyboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Keyboard Screen',
        style: TextStyle(fontSize: 24, color: Colors.red),
      ),
    );
  }
}
