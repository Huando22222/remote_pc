import 'package:flutter/services.dart';

class NativeMouseDatasource {
  static const _channel = MethodChannel('remote.control');

  Future<void> moveMouse(double dx, double dy) async {
    await _channel.invokeMethod('moveMouse', {'dx': dx, 'dy': dy});
  }

  Future<void> click() async {
    await _channel.invokeMethod('click');
  }
}
