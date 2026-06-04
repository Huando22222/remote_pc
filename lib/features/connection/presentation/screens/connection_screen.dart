import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pc_remote/common/widgets/swipe_widget.dart';
import 'package:pc_remote/core/config/routes.dart';
import 'package:pc_remote/core/constants/app_links.dart';
import 'package:pc_remote/core/helpers/in_app_notification_helper.dart';
import 'package:pc_remote/core/theme/app_spacing.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_history_provider.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_provider.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_status.dart';
import 'package:pc_remote/features/device/presentation/providers/remote_device_provider.dart';
import 'package:pc_remote/features/file_transfer/presentation/providers/downloaded_files_provider.dart';
import 'package:pc_remote/features/file_transfer/presentation/widgets/downloaded_files_sheet.dart';
import 'package:pc_remote/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConsumerState<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  final _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Auto-connect is temporarily disabled until the reconnect flow is stable.
    // Future.microtask(_tryAutoConnect);
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    final ip = _ipController.text.trim();

    if (!_isIpv4(ip)) {
      InAppNotificationHelper.warning(
        context,
        title: 'Invalid IP',
        message: 'Enter a valid PC IP, for example 192.168.X.XX.',
      );
      return;
    }

    try {
      await ref.read(appSettingsProvider.notifier).setLastConnectedIp(ip);
      await ref.read(connectionHistoryProvider.notifier).upsertIp(ip);
      await ref.read(connectionNotifierProvider.notifier).connect(ip);
      final remoteDevices = ref.read(remoteDeviceProvider);
      if (remoteDevices.isNotEmpty) {
        await ref.read(connectionHistoryProvider.notifier).updateDeviceInfo(
              remoteDevices.first,
              connectedIp: ip,
            );
      }
    } catch (_) {
      if (!mounted) return;
      InAppNotificationHelper.error(
        context,
        title: 'Connection failed',
        message:
            'Cannot connect to PC. Check that both devices are on the same Wi-Fi and the server is running.',
      );
    }
  }

  void _openQrScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QrScannerPage(
          onScanned: (ip) {
            _ipController.text = ip;
            _handleConnect();
          },
        ),
      ),
    );
  }

  void _openConnectionHistory() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final history = ref.watch(connectionHistoryProvider);
            return _ConnectionHistorySheet(
              history: history,
              onSelected: (entry) {
                Navigator.of(context).pop();
                _ipController.text = entry.ip;
                _handleConnect();
              },
              onDelete: (entry) {
                ref.read(connectionHistoryProvider.notifier).removeIp(entry.ip);
              },
            );
          },
        );
      },
    );
  }

  bool _isIpv4(String value) {
    final parts = value.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final number = int.tryParse(part);
      if (number == null || number < 0 || number > 255) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(connectionNotifierProvider);
    final downloadedFiles = ref.watch(downloadedFilesProvider);
    final settings = ref.watch(appSettingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, topPadding, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AppHeader(),
              const SizedBox(height: 14),
              const _DesktopDownloadBanner(),
              const SizedBox(height: 20),
              const _FeatureGrid(),
              const SizedBox(height: 20),
              _ConnectionCard(
                ipController: _ipController,
                status: status,
                autoConnect: settings.autoConnect,
                onConnect: _handleConnect,
                onScanQr: _openQrScanner,
                onOpenHistory: _openConnectionHistory,
                onAutoConnectChanged:
                    ref.read(appSettingsProvider.notifier).setAutoConnect,
              ),
              const SizedBox(height: 14),
              _DownloadedFilesEntry(count: downloadedFiles.length),
              const SizedBox(height: 14),
              Text(
                'Make sure your phone and PC are on the same Wi-Fi network.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.55),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopDownloadBanner extends StatelessWidget {
  const _DesktopDownloadBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.primaryContainer.withOpacity(0.65),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _openDesktopDownloadLink,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.desktop_windows_rounded,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need the desktop app?',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Download Remote PC Server before connecting.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.72),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.open_in_new_rounded,
                color: colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDesktopDownloadLink() async {
    final uri = Uri.parse(AppLinks.desktopServerDownload);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.touch_app_rounded,
            size: 30,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PC Remote',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                'Control your computer from your phone',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: 'Settings',
          child: IconButton.filledTonal(
            onPressed: () => context.go(Routes.settings),
            icon: const Icon(Icons.settings_rounded),
            style: IconButton.styleFrom(
              fixedSize: const Size(48, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          children: [
            Expanded(
              child: _FeatureCard(
                icon: Icons.touch_app_rounded,
                label: 'Touchpad',
                description: 'Move, click, scroll',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _FeatureCard(
                icon: Icons.keyboard_rounded,
                label: 'Keyboard',
                description: 'Type and shortcuts',
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _FeatureCard(
                icon: Icons.folder_zip_rounded,
                label: 'Files',
                description: 'Send and receive',
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: SizedBox())
          ],
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurface.withOpacity(0.55),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionHistorySheet extends StatelessWidget {
  const _ConnectionHistorySheet({
    required this.history,
    required this.onSelected,
    required this.onDelete,
  });

  final List<ConnectionHistoryEntry> history;
  final ValueChanged<ConnectionHistoryEntry> onSelected;
  final ValueChanged<ConnectionHistoryEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connected PCs',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (history.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No connected PC yet',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              Flexible(
                child: _ConnectionHistoryList(
                  shrinkWrap: true,
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return SwipeWidget(
                      actions: [
                        SwipeAction(
                          icon: Icons.delete_outline_rounded,
                          label: 'Delete',
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                          onTap: () => onDelete(item),
                        ),
                      ],
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: colorScheme.surfaceContainerHighest
                            .withOpacity(0.45),
                        leading: const Icon(Icons.computer_rounded),
                        title: Text(
                          item.deviceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          [
                            item.ip,
                            if (item.platform.isNotEmpty) item.platform,
                          ].join(' • '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => onSelected(item),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionHistoryList extends StatelessWidget {
  const _ConnectionHistoryList({
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final bool shrinkWrap;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
        children: List.generate(itemCount, (index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              itemBuilder(context, index),
              if (index < itemCount - 1) separatorBuilder(context, index),
            ],
          );
        }),
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.ipController,
    required this.status,
    required this.autoConnect,
    required this.onConnect,
    required this.onScanQr,
    required this.onOpenHistory,
    required this.onAutoConnectChanged,
  });

  final TextEditingController ipController;
  final ConnectionStatus status;
  final bool autoConnect;
  final VoidCallback onConnect;
  final VoidCallback onScanQr;
  final VoidCallback onOpenHistory;
  final ValueChanged<bool> onAutoConnectChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isConnected = status == ConnectionStatus.connected;
    final isConnecting = status == ConnectionStatus.connecting;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.lan_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Connect to PC',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ipController,
            keyboardType: TextInputType.url,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              labelText: 'PC IP address',
              hintText: '192.168.x.x',
              prefixIcon: const Icon(Icons.computer_rounded),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner_rounded),
                tooltip: 'Scan QR',
                onPressed: onScanQr,
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onOpenHistory,
            icon: const Icon(Icons.history_rounded),
            label: const Text('Connected PCs'),
          ),
          // Auto-connect is temporarily hidden until the reconnect flow is stable.
          // CheckboxListTile(
          //   value: autoConnect,
          //   onChanged: (value) => onAutoConnectChanged(value ?? true),
          //   contentPadding: EdgeInsets.zero,
          //   controlAffinity: ListTileControlAffinity.leading,
          //   title: const Text('Auto connect'),
          //   subtitle: const Text('Reconnect to this PC next time'),
          // ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: isConnected || isConnecting ? null : onConnect,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              isConnected
                  ? Icons.check_circle_rounded
                  : isConnecting
                      ? Icons.sync_rounded
                      : Icons.link_rounded,
            ),
            label: Text(
              isConnected
                  ? 'Connected'
                  : isConnecting
                      ? 'Connecting'
                      : 'Connect',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key, required this.onScanned});

  final void Function(String ip) onScanned;

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _handled = false;
  double _zoomScale = 0;
  double _baseZoomScale = 0;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    final rawValue = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .whereType<String>()
        .firstWhere(
          (value) => value.trim().isNotEmpty,
          orElse: () => '',
        );
    final ip = _extractIp(rawValue);
    if (ip == null) return;

    _handled = true;
    _scannerController.stop();

    Navigator.of(context).pop();
    widget.onScanned(ip);
  }

  String? _extractIp(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.host.isNotEmpty && _isIpv4(uri.host)) {
      return uri.host;
    }

    final match = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b').firstMatch(trimmed);
    final ip = match?.group(0);
    if (ip == null || !_isIpv4(ip)) return null;

    return ip;
  }

  bool _isIpv4(String value) {
    final parts = value.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final number = int.tryParse(part);
      if (number == null || number < 0 || number > 255) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flashlight_on_rounded),
            tooltip: 'Toggle flash',
            onPressed: _scannerController.toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded),
            tooltip: 'Switch camera',
            onPressed: _scannerController.switchCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: (details) {
              if (details.pointerCount < 2) return;
              _baseZoomScale = _zoomScale;
            },
            onScaleUpdate: (details) {
              if (details.pointerCount < 2) return;
              final nextZoom =
                  (_baseZoomScale + (details.scale - 1) * 0.7).clamp(0.0, 1.0);
              if ((nextZoom - _zoomScale).abs() < 0.01) return;
              setState(() => _zoomScale = nextZoom);
              _scannerController.setZoomScale(nextZoom);
            },
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
            ),
          ),
          const _ScannerOverlay(),
          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: _ZoomIndicator(zoomScale: _zoomScale),
          ),
        ],
      ),
    );
  }
}

class _ZoomIndicator extends StatelessWidget {
  const _ZoomIndicator({required this.zoomScale});

  final double zoomScale;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: AnimatedOpacity(
          opacity: zoomScale > 0.02 ? 1 : 0,
          duration: const Duration(milliseconds: 160),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.62),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Zoom ${(1 + zoomScale * 3).toStringAsFixed(1)}x',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const cutoutSize = 240.0;
        final centerX = constraints.maxWidth / 2;
        final centerY = constraints.maxHeight / 2;
        final left = centerX - cutoutSize / 2;
        final top = centerY - cutoutSize / 2;

        return Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.55),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    left: left,
                    top: top,
                    child: Container(
                      width: cutoutSize,
                      height: cutoutSize,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: const _CornerBrackets(size: cutoutSize),
            ),
            Positioned(
              left: 24,
              right: 24,
              top: top + cutoutSize + 24,
              child: const Text(
                'Point the camera at the QR code on your PC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CornerBrackets extends StatelessWidget {
  const _CornerBrackets({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: const _BracketPainter(
          bracketLength: 28,
          bracketWidth: 3.5,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter({
    required this.bracketLength,
    required this.bracketWidth,
    required this.color,
  });

  final double bracketLength;
  final double bracketWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = bracketWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final corners = [
      [Offset(0, bracketLength), Offset.zero, Offset(bracketLength, 0)],
      [
        Offset(size.width - bracketLength, 0),
        Offset(size.width, 0),
        Offset(size.width, bracketLength),
      ],
      [
        Offset(0, size.height - bracketLength),
        Offset(0, size.height),
        Offset(bracketLength, size.height),
      ],
      [
        Offset(size.width - bracketLength, size.height),
        Offset(size.width, size.height),
        Offset(size.width, size.height - bracketLength),
      ],
    ];

    for (final pts in corners) {
      final path = Path()
        ..moveTo(pts[0].dx, pts[0].dy)
        ..lineTo(pts[1].dx, pts[1].dy)
        ..lineTo(pts[2].dx, pts[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DownloadedFilesEntry extends StatelessWidget {
  const _DownloadedFilesEntry({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => showDownloadedFilesSheet(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.45),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.download_done_rounded, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Downloaded files',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    count == 0
                        ? 'No files downloaded yet'
                        : '$count file(s) ready to open or share',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_up_rounded),
          ],
        ),
      ),
    );
  }
}
