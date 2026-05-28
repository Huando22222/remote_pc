import 'package:flutter/material.dart';

class DialogHelper {
  DialogHelper._();

  static Future<T?> showAppDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }
}
