import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/peer_device.dart';
import '../providers/transfer_provider.dart';

/// Pairing state machine.
enum _PairingPhase { scanning, connecting, verifying, connected, error }

/// Camera-based QR code scanner with secure pairing handshake.
///
/// Flow:
///   1. Camera scans for QR code
///   2. On detection: decode → validate → connect via HTTP /pair
///   3. Show verification code for user confirmation
///   4. On confirm: connection is ready for file transfer
class QrScanScreen extends ConsumerStatefulWidget {
  const QrScanScreen({super.key, this.filePaths = const []});

  final List<String> filePaths;

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen>
    with SingleTickerProviderStateMixin {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  late final AnimationController _scanLineController;

  _PairingPhase _phase = _PairingPhase.scanning;
  PeerDevice? _connectedPeer;
  String? _verificationCode;
  String? _error;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _phase == _PairingPhase.scanning
              ? 'Scan QR Code'
              : _phase == _PairingPhase.connecting
                  ? 'Connecting...'
                  : _phase == _PairingPhase.verifying
                      ? 'Verify Connection'
                      : _phase == _PairingPhase.connected
                          ? 'Connected'
                          : 'Error',
        ),
        actions: [
          if (_phase == _PairingPhase.scanning) ...[
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (_, state, _) {
                  return Icon(
                    state.torchState == TorchState.on
                        ? Icons.flash_on
                        : Icons.flash_off,
                    color: state.torchState == TorchState.on
                        ? AppColors.warning
                        : Colors.white,
                  );
                },
              ),
              onPressed: () => _controller.toggleTorch(),
            ),
            IconButton(
              icon: const Icon(Icons.flip_camera_android),
              onPressed: () => _controller.switchCamera(),
            ),
          ],
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (_phase) {
          _PairingPhase.scanning => _buildScanView(theme),
          _PairingPhase.connecting => _buildConnectingView(theme),
          _PairingPhase.verifying => _buildVerifyView(theme),
          _PairingPhase.connected => _buildConnectedView(theme),
          _PairingPhase.error => _buildErrorView(theme),
        },
      ),
    );
  }

  // ── Scanning view ──────────────────────────────────────────────────────

  Widget _buildScanView(ThemeData theme) {
    return Stack(
      key: const ValueKey('scan'),
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _handleDetection,
        ),

        // Overlay with cutout.
        _ScanOverlay(animationController: _scanLineController),

        // Bottom instructions.
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(220),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code_scanner,
                    color: Colors.white70, size: 28),
                const SizedBox(height: 12),
                Text(
                  'Point your camera at the QR code\non the other device',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Both devices must have MX Video installed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Connecting view ────────────────────────────────────────────────────

  Widget _buildConnectingView(ThemeData theme) {
    return Center(
      key: const ValueKey('connecting'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              color: AppColors.primaryLight,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Connecting...',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Exchanging device information',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  // ── Verification view ──────────────────────────────────────────────────

  Widget _buildVerifyView(ThemeData theme) {
    return Center(
      key: const ValueKey('verify'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withAlpha(20),
              ),
              child: const Icon(Icons.verified_user_outlined,
                  color: AppColors.primaryLight, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'Verify Connection',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Confirm this code matches on both devices',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Verification code display.
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primaryLight.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0;
                      i < (_verificationCode?.length ?? 0);
                      i++) ...[
                    if (i == 2)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '—',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white.withAlpha(100),
                          ),
                        ),
                      ),
                    Text(
                      _verificationCode![i],
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Connected peer info.
            if (_connectedPeer != null)
              Text(
                'Connected to: ${_connectedPeer!.name}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.primaryLight,
                ),
              ),

            const SizedBox(height: 36),

            // Action buttons.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: _reject,
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text('Confirm'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: _confirm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Connected view ─────────────────────────────────────────────────────

  Widget _buildConnectedView(ThemeData theme) {
    final peer = _connectedPeer!;

    return Center(
      key: const ValueKey('connected'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success animation.
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (_, value, child) => Transform.scale(
                scale: value,
                child: child,
              ),
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withAlpha(20),
                ),
                child: const Icon(Icons.check_circle,
                    color: AppColors.success, size: 60),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Securely Connected',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Peer info card.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _platformIcon(peer.platform),
                    color: AppColors.primaryLight,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          peer.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${peer.ipAddress}:${peer.port}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock,
                            color: AppColors.success, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Encrypted',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons.
            if (_isSending)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Sending...', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              )
            else
              FilledButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Send Files'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                ),
                onPressed: () => _pickAndSendFiles(peer),
              ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white30),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error view ─────────────────────────────────────────────────────────

  Widget _buildErrorView(ThemeData theme) {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withAlpha(20),
              ),
              child: const Icon(Icons.error_outline,
                  color: AppColors.error, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'Connection Failed',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              onPressed: _resetToScan,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white30),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Handlers ───────────────────────────────────────────────────────────

  Future<void> _pickAndSendFiles(PeerDevice peer) async {
    List<String> filePaths;

    if (widget.filePaths.isNotEmpty) {
      filePaths = widget.filePaths;
    } else {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result == null || result.paths.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No files selected')),
          );
        }
        return;
      }
      filePaths = result.paths.whereType<String>().toList();
      if (filePaths.isEmpty) return;
    }

    if (!mounted) return;
    setState(() => _isSending = true);

    try {
      final repo = await ref.read(transferRepositoryProvider.future);
      await repo.sendFiles(peer, filePaths);
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      unawaited(GoRouter.of(context).push(RouteNames.transferProgress));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transfer failed: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_phase != _PairingPhase.scanning) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    // Haptic feedback on detection.
    unawaited(HapticFeedback.mediumImpact());

    setState(() => _phase = _PairingPhase.connecting);

    try {
      // Decode QR data.
      final qrSource = ref.read(qrPairingSourceProvider);
      final data = qrSource.decodePairingData(barcode!.rawValue!);

      if (data == null) {
        _showError('Not a valid MX Video QR code');
        return;
      }

      // Check if expired.
      if (qrSource.isExpired(data)) {
        _showError(
            'This QR code has expired.\nAsk the other device to refresh.');
        return;
      }

      // Connect via the transfer manager (HTTP /pair handshake).
      final peer = await ref
          .read(transferManagerProvider.notifier)
          .connectFromQr(barcode.rawValue!);

      if (peer == null) {
        _showError('Failed to connect. Is the other device nearby?');
        return;
      }

      _connectedPeer = peer;

      // Derive verification code from QR token + session token.
      // Both sides use the same two values, so codes will match.
      final qrToken = data['token'] as String? ?? '';
      final sessionToken = peer.sessionToken ?? '';
      _verificationCode =
          qrSource.deriveVerificationCode(qrToken, sessionToken);

      await _controller.stop();

      if (mounted) {
        setState(() => _phase = _PairingPhase.verifying);
      }
    } catch (e) {
      _showError('Connection error: $e');
    }
  }

  void _confirm() {
    HapticFeedback.heavyImpact();
    setState(() => _phase = _PairingPhase.connected);
  }

  void _reject() {
    _connectedPeer = null;
    _verificationCode = null;
    _resetToScan();
  }

  void _showError(String message) {
    if (mounted) {
      setState(() {
        _error = message;
        _phase = _PairingPhase.error;
      });
    }
  }

  void _resetToScan() {
    _controller.start();
    setState(() {
      _phase = _PairingPhase.scanning;
      _error = null;
      _connectedPeer = null;
      _verificationCode = null;
    });
  }

  IconData _platformIcon(PeerPlatform platform) => switch (platform) {
        PeerPlatform.android => Icons.phone_android,
        PeerPlatform.ios => Icons.phone_iphone,
        PeerPlatform.windows => Icons.laptop_windows,
        PeerPlatform.macos => Icons.laptop_mac,
        PeerPlatform.linux => Icons.computer,
        PeerPlatform.unknown => Icons.devices_other,
      };
}

// ── Scan overlay with animated line ──────────────────────────────────────

class _ScanOverlay extends StatelessWidget {
  const _ScanOverlay({required this.animationController});

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark overlay with cutout.
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(140),
            BlendMode.srcOut,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Corner brackets.
        Center(
          child: SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(painter: _CornerPainter()),
          ),
        ),

        // Animated scan line.
        Center(
          child: SizedBox(
            width: 240,
            height: 260,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (_, _) {
                return Align(
                  alignment: Alignment(
                      0, -1 + 2 * animationController.value),
                  child: Container(
                    width: 220,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primaryLight.withAlpha(200),
                          AppColors.primaryLight,
                          AppColors.primaryLight.withAlpha(200),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryLight.withAlpha(80),
                          blurRadius: 12,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Paints corner brackets around the scan area.
class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryLight
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 30.0;
    const r = 12.0;

    // Top-left.
    canvas.drawPath(
      Path()
        ..moveTo(0, len)
        ..lineTo(0, r)
        ..quadraticBezierTo(0, 0, r, 0)
        ..lineTo(len, 0),
      paint,
    );

    // Top-right.
    canvas.drawPath(
      Path()
        ..moveTo(size.width - len, 0)
        ..lineTo(size.width - r, 0)
        ..quadraticBezierTo(size.width, 0, size.width, r)
        ..lineTo(size.width, len),
      paint,
    );

    // Bottom-left.
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - len)
        ..lineTo(0, size.height - r)
        ..quadraticBezierTo(0, size.height, r, size.height)
        ..lineTo(len, size.height),
      paint,
    );

    // Bottom-right.
    canvas.drawPath(
      Path()
        ..moveTo(size.width - len, size.height)
        ..lineTo(size.width - r, size.height)
        ..quadraticBezierTo(
            size.width, size.height, size.width, size.height - r)
        ..lineTo(size.width, size.height - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
