import 'package:flutter/material.dart';

class InAppNotificationHelper {
  static OverlayEntry? _currentOverlay;

  // Medical/Healthcare Color Palette
  static const Color medicalPrimary = Color(0xFF0077BE); // Xanh nước biển chính
  static const Color medicalLight = Color(0xFF4DA6D6); // Xanh nhạt
  static const Color medicalDark = Color(0xFF005A8C); // Xanh đậm
  static const Color medicalAccent = Color(0xFF00A8E8); // Xanh accent
  // Cập nhật lại Palette màu trong class InAppNotificationHelper
  static const Color medicalSuccess = Color(
    0xFF2E7D32,
  ); // Xanh lá đậm (Success)
  static const Color medicalWarning = Color(0xFFF9A825); // Vàng cam (Warning)
  static const Color medicalError = Color(0xFFD32F2F); // Đỏ y tế (Error/Alert)
  static const Color medicalInfo = Color(0xFF0288D1); // Xanh dương (Info)

  /// Hiển thị thông báo in-app với widget tùy chỉnh
  static void show(
    BuildContext context, {
    required Widget child,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool showClose = false,
    NotificationPosition position = NotificationPosition.top,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    bool autoDismiss = true,
  }) {
    // Dismiss notification hiện tại nếu có
    dismiss();

    final overlay = Overlay.of(context);

    _currentOverlay = OverlayEntry(
      builder: (context) => _InAppNotification(
        child: child,
        isDismissible: isDismissible,
        showClose: showClose,
        position: position,
        onTap: onTap,
        onDismiss: () {
          dismiss();
          onDismiss?.call();
        },
      ),
    );

    overlay.insert(_currentOverlay!);

    // Auto dismiss sau duration
    if (autoDismiss) {
      Future.delayed(duration, () {
        // ⭐ Kiểm tra lại overlay còn tồn tại không trước khi dismiss
        if (_currentOverlay != null) {
          dismiss();
        }
      });
    }
  }

  /// Hiển thị thông báo với template mặc định
  static void showDefault(
    BuildContext context, {
    required String message,
    String? title,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Color? iconColor,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool showClose = false,
    NotificationPosition position = NotificationPosition.top,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    double? height,
    EdgeInsetsGeometry? padding,
    bool autoDismiss = true,
    double? fsTitle,
    double? fsMessage,
  }) {
    show(
      context,
      child: _DefaultNotificationContent(
        message: message,
        title: title,
        backgroundColor: backgroundColor ?? medicalPrimary,
        textColor: textColor ?? Colors.white,
        icon: icon,
        iconColor: iconColor,
        position: position,
        padding: padding,
        fsTitle: fsTitle,
        fsMessage: fsMessage,
      ),
      duration: duration,
      isDismissible: isDismissible,
      showClose: showClose,
      position: position,
      onTap: onTap,
      onDismiss: onDismiss,
      autoDismiss: autoDismiss,
    );
  }

  /// Success notification - Y tế
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool showClose = false,
    NotificationPosition position = NotificationPosition.top,
    VoidCallback? onTap,
    double? fsTitle,
    double? fsMessage,
  }) {
    showDefault(
      context,
      message: message,
      title: title ?? 'Thành công',
      backgroundColor: medicalSuccess,
      icon: Icons.check_circle,
      iconColor: Colors.white,
      duration: duration,
      isDismissible: isDismissible,
      showClose: showClose,
      position: position,
      onTap: onTap,
      fsTitle: fsTitle,
      fsMessage: fsMessage,
    );
  }

  /// Error notification - Y tế
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool showClose = false,
    NotificationPosition position = NotificationPosition.top,
    VoidCallback? onTap,
    double? fsTitle,
    double? fsMessage,
  }) {
    showDefault(
      context,
      message: message,
      title: title ?? 'Lưu ý',
      backgroundColor: medicalError,
      icon: Icons.error,
      iconColor: Colors.white,
      duration: duration,
      isDismissible: isDismissible,
      showClose: showClose,
      position: position,
      onTap: onTap,
      fsTitle: fsTitle,
      fsMessage: fsMessage,
    );
  }

  /// Warning notification - Y tế
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool showClose = false,
    NotificationPosition position = NotificationPosition.top,
    VoidCallback? onTap,
    double? fsTitle,
    double? fsMessage,
  }) {
    showDefault(
      context,
      message: message,
      title: title ?? 'Cảnh báo',
      backgroundColor: medicalWarning,
      icon: Icons.warning,
      iconColor: Colors.white,
      duration: duration,
      isDismissible: isDismissible,
      showClose: showClose,
      position: position,
      onTap: onTap,
      fsTitle: fsTitle,
      fsMessage: fsMessage,
    );
  }

  /// Info notification - Y tế
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool showClose = false,
    NotificationPosition position = NotificationPosition.top,
    VoidCallback? onTap,
    bool autoDismiss = true,
    double? fsTitle,
    double? fsMessage,
  }) {
    showDefault(
      context,
      message: message,
      title: title ?? 'Thông tin',
      backgroundColor: medicalInfo,
      icon: Icons.info,
      iconColor: Colors.white,
      duration: duration,
      isDismissible: isDismissible,
      autoDismiss: autoDismiss,
      showClose: showClose,
      position: position,
      onTap: onTap,
      fsTitle: fsTitle,
      fsMessage: fsMessage,
    );
  }

  /// Dismiss notification hiện tại
  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

enum NotificationPosition { top, bottom }

class _InAppNotification extends StatefulWidget {
  final Widget child;
  final bool isDismissible;
  final bool showClose;
  final NotificationPosition position;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const _InAppNotification({
    required this.child,
    required this.isDismissible,
    required this.showClose,
    required this.position,
    this.onTap,
    required this.onDismiss,
  });

  @override
  State<_InAppNotification> createState() => _InAppNotificationState();
}

class _InAppNotificationState extends State<_InAppNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Animation từ top hoặc bottom
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.position == NotificationPosition.top ? -1 : 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position == NotificationPosition.top ? 0 : null,
      bottom: widget.position == NotificationPosition.bottom ? 0 : null,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onTap,
              onVerticalDragEnd: widget.isDismissible
                  ? (details) {
                      // Swipe to dismiss
                      if (widget.position == NotificationPosition.top &&
                          details.primaryVelocity! < -500) {
                        _dismiss();
                      } else if (widget.position ==
                              NotificationPosition.bottom &&
                          details.primaryVelocity! > 500) {
                        _dismiss();
                      }
                    }
                  : null,
              child: Stack(
                children: [
                  // Content
                  Container(width: double.infinity, child: widget.child),

                  // Close button
                  if (widget.showClose)
                    Positioned(
                      top: widget.position == NotificationPosition.top
                          ? null
                          : 8,
                      bottom: widget.position == NotificationPosition.bottom
                          ? null
                          : 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _dismiss,
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black26,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget template mặc định
class _DefaultNotificationContent extends StatelessWidget {
  final String message;
  final String? title;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final NotificationPosition position;
  final double? fsTitle;
  final double? fsMessage;

  const _DefaultNotificationContent({
    required this.message,
    this.title,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.iconColor,
    this.padding,
    required this.position,
    this.fsTitle,
    this.fsMessage,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    return Container(
      width: double.infinity,
      padding: padding ??
          EdgeInsets.fromLTRB(
            16,
            position == NotificationPosition.top ? topPadding : 12,
            16,
            position == NotificationPosition.bottom ? bottomPadding + 12 : 12,
          ), // ⭐ Bỏ comment dòng này
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? textColor, size: 24),
            const SizedBox(width: 12),
          ],

          // Content
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fsTitle ?? 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: fsMessage ?? 14),
                ),
              ],
            ),
          ),

          const SizedBox(width: 32),
        ],
      ),
    );
  }
}
