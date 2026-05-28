import 'package:flutter/material.dart';

class InAppNotificationHelper {
  InAppNotificationHelper._();

  static OverlayEntry? _currentOverlay;

  static const Color _success = Color(0xFF1F8A4C);
  static const Color _error = Color(0xFFD92D20);
  static const Color _warning = Color(0xFFB7791F);
  static const Color _info = Color(0xFF2563EB);

  static void success(
    BuildContext context, {
    required String message,
    String title = 'Success',
    Duration duration = const Duration(seconds: 3),
  }) {
    _showTyped(
      context,
      title: title,
      message: message,
      color: _success,
      icon: Icons.check_circle_rounded,
      duration: duration,
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    String title = 'Error',
    Duration duration = const Duration(seconds: 4),
  }) {
    _showTyped(
      context,
      title: title,
      message: message,
      color: _error,
      icon: Icons.error_rounded,
      duration: duration,
    );
  }

  static void warning(
    BuildContext context, {
    required String message,
    String title = 'Warning',
    Duration duration = const Duration(seconds: 4),
  }) {
    _showTyped(
      context,
      title: title,
      message: message,
      color: _warning,
      icon: Icons.warning_rounded,
      duration: duration,
    );
  }

  static void info(
    BuildContext context, {
    required String message,
    String title = 'Info',
    Duration duration = const Duration(seconds: 3),
  }) {
    _showTyped(
      context,
      title: title,
      message: message,
      color: _info,
      icon: Icons.info_rounded,
      duration: duration,
    );
  }

  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  static void _showTyped(
    BuildContext context, {
    required String title,
    required String message,
    required Color color,
    required IconData icon,
    required Duration duration,
  }) {
    dismiss();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    _currentOverlay = OverlayEntry(
      builder: (context) {
        final topPadding = MediaQuery.paddingOf(context).top;

        return Positioned(
          top: topPadding + 12,
          left: 16,
          right: 16,
          child: _NotificationCard(
            title: title,
            message: message,
            color: color,
            icon: icon,
            onClose: dismiss,
          ),
        );
      },
    );

    overlay.insert(_currentOverlay!);

    Future.delayed(duration, () {
      if (_currentOverlay != null) dismiss();
    });
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
    required this.onClose,
  });

  final String title;
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
              color: Colors.white,
              iconSize: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}