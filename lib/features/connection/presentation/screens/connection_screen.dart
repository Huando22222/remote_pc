import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pc_remote/core/config/routes.dart';
import 'package:pc_remote/core/helpers/in_app_notification_helper.dart';
import 'package:pc_remote/core/theme/app_spacing.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_provider.dart';
import 'package:pc_remote/features/connection/presentation/providers/connection_status.dart';
import 'package:pc_remote/features/file_transfer/presentation/providers/downloaded_files_provider.dart';
import 'package:pc_remote/features/file_transfer/presentation/widgets/downloaded_files_sheet.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Presentation Layer â€” ConnectionPage
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConsumerState<ConnectionScreen> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends ConsumerState<ConnectionScreen> {
  final _ipController = TextEditingController();

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
        message: 'Enter a valid PC IP, for example 192.168.1.10.',
      );
      return;
    }

    try {
      await ref.read(connectionNotifierProvider.notifier).connect(ip);
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

  bool _isIpv4(String value) {
    final parts = value.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final number = int.tryParse(part);
      if (number == null || number < 0 || number > 255) return false;
    }

    return true;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(connectionNotifierProvider, (prev, next) {
      if (next == ConnectionStatus.connected) context.go(Routes.touchpad);
    });

    final connectionStatus = ref.watch(connectionNotifierProvider);
    final isConnected = connectionStatus == ConnectionStatus.connected;
    final isConnecting = connectionStatus == ConnectionStatus.connecting;
    final downloadedFiles = ref.watch(downloadedFilesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final md = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: md.padding.top + 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // â”€â”€ Header â”€â”€
              _AppHeader(),

              const SizedBox(height: 32),

              // â”€â”€ Feature Cards â”€â”€
              _FeatureGrid(),

              const SizedBox(height: 32),

              // â”€â”€ Connection Card â”€â”€
              _ConnectionCard(
                ipController: _ipController,
                isConnected: isConnected,
                isConnecting: isConnecting,
                onConnect: _handleConnect,
                onScanQr: _openQrScanner,
              ),

              const SizedBox(height: 24),

              _DownloadedFilesEntry(count: downloadedFiles.length),

              const SizedBox(height: 24),

              // â”€â”€ Help hint â”€â”€
              Center(
                child: Text(
                  'Äáº£m báº£o Ä‘iá»‡n thoáº¡i vÃ  mÃ¡y tÃ­nh\ncÃ¹ng káº¿t ná»‘i má»™t máº¡ng Wi-Fi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.45),
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Header
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      spacing: 10,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon

              const SizedBox(height: 16),
              Text(
                'PC Remote',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Äiá»u khiá»ƒn mÃ¡y tÃ­nh tá»« Ä‘iá»‡n thoáº¡i cá»§a báº¡n',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.55),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Feature Grid
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _FeatureGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return GridView.count(
    //   crossAxisCount: 2,
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   crossAxisSpacing: 12,
    //   mainAxisSpacing: 12,
    //   childAspectRatio: 1.55,
    //   children: _features.map((f) => _FeatureCard(item: f)).toList(),
    // );
    return Column(
      spacing: 10,
      children: [
        IntrinsicHeight(
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: _FeatureCard(
                  item: _FeatureItem(
                    icon: Icons.touch_app_rounded,
                    label: 'Touchpad',
                    desc: 'Cháº¡m & kÃ©o nhÆ° chuá»™t tháº­t',
                  ),
                ),
              ),
              Expanded(
                child: _FeatureCard(
                  item: _FeatureItem(
                    icon: Icons.keyboard_rounded,
                    label: 'BÃ n phÃ­m',
                    desc: 'GÃµ vÄƒn báº£n tá»« xa',
                  ),
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: _FeatureCard(
                  item: _FeatureItem(
                    icon: Icons.folder_zip_rounded,
                    label: 'Chuyá»ƒn file',
                    desc: 'Gá»­i file tá»« Ä‘iá»‡n thoáº¡i sang PC',
                  ),
                ),
              ),
              Expanded(
                child: _FeatureCard(
                  item: _FeatureItem(
                    icon: Icons.content_paste_rounded,
                    label: 'Clipboard',
                    desc: 'Sao chÃ©p vÄƒn báº£n tá»« ÄT sang PC',
                  ),
                ),
              ),
              // Expanded(
              //   child: _FeatureCard(
              //     item: _FeatureItem(
              //       icon: Icons.wifi_rounded,
              //       label: 'Wi-Fi LAN',
              //       desc: 'Káº¿t ná»‘i ná»™i bá»™, siÃªu nhanh',
              //     ),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.desc,
  });
  final IconData icon;
  final String label;
  final String desc;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.item});
  final _FeatureItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(item.icon, size: 22, color: colorScheme.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.desc,
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurface.withOpacity(0.5),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Connection Card
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.ipController,
    required this.isConnected,
    required this.isConnecting,
    required this.onConnect,
    required this.onScanQr,
  });

  final TextEditingController ipController;
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onScanQr;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          // Title row
          Row(
            children: [
              Icon(Icons.lan_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Connect to PC',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // IP Input
          TextField(
            controller: ipController,
            keyboardType: TextInputType.url,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
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

          const SizedBox(height: 12),

          // Connect Button
          FilledButton.icon(
            onPressed: isConnected || isConnecting ? null : onConnect,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // const SizedBox(height: 10),

          // // Divider
          // Row(
          //   children: [
          //     const Expanded(child: Divider()),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 12),
          //       child: Text(
          //         'hoáº·c',
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: colorScheme.onSurface.withOpacity(0.4),
          //         ),
          //       ),
          //     ),
          //     const Expanded(child: Divider()),
          //   ],
          // ),

          // const SizedBox(height: 10),

          // // QR Button
          // OutlinedButton.icon(
          //   onPressed: onScanQr,
          //   style: OutlinedButton.styleFrom(
          //     padding: const EdgeInsets.symmetric(vertical: 13),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          //   icon: const Icon(Icons.qr_code_scanner_rounded),
          //   label: const Text(
          //     'QuÃ©t mÃ£ QR',
          //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          //   ),
          // ),
        ],
      ),
    );
  }
}

//MARK: QR Scanner Page

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key, required this.onScanned});

  final void Function(String ip) onScanned;

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _handled = false;

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
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),
          _ScannerOverlay(),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Scanner Overlay
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ScannerOverlay extends StatelessWidget {
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
              child: _CornerBrackets(size: cutoutSize),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: top + cutoutSize + 24,
              child: const Text(
                'Point the camera at the QR code on your PC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
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
        painter: _BracketPainter(
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
            Icon(
              Icons.download_done_rounded,
              color: colorScheme.primary,
            ),
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
