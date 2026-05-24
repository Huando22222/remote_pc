import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pc_remote/core/config/routes.dart';
import 'package:pc_remote/features/connection/presentation/notifier/connection_notifier.dart';

// ─────────────────────────────────────────────
// Presentation Layer — ConnectionPage
// ─────────────────────────────────────────────

class ConnectionPage extends ConsumerStatefulWidget {
  const ConnectionPage({super.key});

  @override
  ConsumerState<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends ConsumerState<ConnectionPage> {
  final _ipController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  void _handleConnect() {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) return;
    ref.read(connectionNotifierProvider.notifier).connect(ip);
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
  Widget build(BuildContext context) {
    ref.listen(connectionNotifierProvider, (prev, next) {
      if (next) context.go(Routes.remote);
    });

    final isConnected = ref.watch(connectionNotifierProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              _AppHeader(),

              const SizedBox(height: 32),

              // ── Feature Cards ──
              _FeatureGrid(),

              const SizedBox(height: 32),

              // ── Connection Card ──
              _ConnectionCard(
                ipController: _ipController,
                isConnected: isConnected,
                onConnect: _handleConnect,
                onScanQr: _openQrScanner,
              ),

              const SizedBox(height: 24),

              // ── Help hint ──
              Center(
                child: Text(
                  'Đảm bảo điện thoại và máy tính\ncùng kết nối một mạng Wi-Fi',
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

// ─────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────

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
                'Điều khiển máy tính từ điện thoại của bạn',
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

// ─────────────────────────────────────────────
// Feature Grid
// ─────────────────────────────────────────────

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
                    desc: 'Chạm & kéo như chuột thật',
                  ),
                ),
              ),
              Expanded(
                child: _FeatureCard(
                  item: _FeatureItem(
                    icon: Icons.keyboard_rounded,
                    label: 'Bàn phím',
                    desc: 'Gõ văn bản từ xa',
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
                    label: 'Chuyển file',
                    desc: 'Gửi file từ điện thoại sang PC',
                  ),
                ),
              ),
              Expanded(
                child: _FeatureCard(
                  item: _FeatureItem(
                    icon: Icons.content_paste_rounded,
                    label: 'Clipboard',
                    desc: 'Sao chép văn bản từ ĐT sang PC',
                  ),
                ),
              ),
              // Expanded(
              //   child: _FeatureCard(
              //     item: _FeatureItem(
              //       icon: Icons.wifi_rounded,
              //       label: 'Wi-Fi LAN',
              //       desc: 'Kết nối nội bộ, siêu nhanh',
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

// ─────────────────────────────────────────────
// Connection Card
// ─────────────────────────────────────────────

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.ipController,
    required this.isConnected,
    required this.onConnect,
    required this.onScanQr,
  });

  final TextEditingController ipController;
  final bool isConnected;
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
                'Kết nối tới máy tính',
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              labelText: 'Địa chỉ IP',
              hintText: '192.168.x.x',
              prefixIcon: const Icon(Icons.computer_rounded),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner_rounded),
                tooltip: 'Quét mã QR',
                onPressed: onScanQr,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Connect Button
          FilledButton.icon(
            onPressed: isConnected ? null : onConnect,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              isConnected ? Icons.check_circle_rounded : Icons.link_rounded,
            ),
            label: Text(
              isConnected ? 'Đã kết nối' : 'Kết nối',
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
          //         'hoặc',
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
          //     'Quét mã QR',
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
    final value = capture.barcodes.firstOrNull?.rawValue;
    if (value == null || value.isEmpty) return;

    _handled = true;
    _scannerController.stop();

    Navigator.of(context).pop();
    widget.onScanned(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flashlight_on_rounded),
            tooltip: 'Bật/tắt đèn flash',
            onPressed: _scannerController.toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded),
            tooltip: 'Đổi camera',
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

// ─────────────────────────────────────────────
// Scanner Overlay
// ─────────────────────────────────────────────

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
                'Hướng camera vào mã QR trên màn hình máy tính',
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
