import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_provider.dart';

/// Pairing phase for the QR display screen.
enum _DisplayPhase { showing, verifying, connected }

/// Shows a QR code that other devices can scan to pair.
///
/// Flow:
///   1. Generate QR code with device info + session token
///   2. Wait for a peer to scan and POST /pair
///   3. Server fires [onPeerPaired] → show 4-digit verification code
///   4. User confirms code matches the other device → connected
class QrDisplayScreen extends ConsumerStatefulWidget {
  const QrDisplayScreen({super.key});

  @override
  ConsumerState<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends ConsumerState<QrDisplayScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  Timer? _refreshTimer;

  _DisplayPhase _phase = _DisplayPhase.showing;
  String? _peerName;
  String? _peerPlatform;
  String? _verificationCode;
  String? _qrToken; // Our token embedded in the QR data.

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Auto-refresh QR every 4 minutes to prevent expiry.
    _refreshTimer = Timer.periodic(const Duration(minutes: 4), (_) {
      if (_phase == _DisplayPhase.showing) {
        ref.invalidate(qrPairingDataProvider);
      }
    });

    // Start listening for incoming connections and wire up pairing callback.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(transferServerProvider).onPeerPaired = _onPeerPaired;
      await ref.read(transferManagerProvider.notifier).startListening();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _refreshTimer?.cancel();
    try {
      ref.read(transferServerProvider).onPeerPaired = null;
    } catch (_) {}
    super.dispose();
  }

  /// Called by the HTTP server when a peer POSTs to /pair.
  void _onPeerPaired(
      String peerName, String peerPlatform, String sessionToken) {
    if (!mounted || _phase != _DisplayPhase.showing) return;
    if (_qrToken == null) return;

    // Both sides derive the same code: hash(sorted(qrToken, sessionToken)).
    final qrSource = ref.read(qrPairingSourceProvider);
    final code = qrSource.deriveVerificationCode(_qrToken!, sessionToken);

    HapticFeedback.mediumImpact();
    setState(() {
      _peerName = peerName;
      _peerPlatform = peerPlatform;
      _verificationCode = code;
      _phase = _DisplayPhase.verifying;
    });
  }

  void _confirm() {
    HapticFeedback.heavyImpact();
    setState(() => _phase = _DisplayPhase.connected);
  }

  void _reject() {
    setState(() {
      _phase = _DisplayPhase.showing;
      _peerName = null;
      _peerPlatform = null;
      _verificationCode = null;
    });
    // Regenerate QR to invalidate the old pairing.
    ref.invalidate(qrPairingDataProvider);
  }

  /// Extract the token from the QR data so we can derive verification codes.
  void _extractQrToken(String qrData) {
    final qrSource = ref.read(qrPairingSourceProvider);
    final data = qrSource.decodePairingData(qrData);
    if (data != null) {
      _qrToken = data['token'] as String?;
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrDataAsync = ref.watch(qrPairingDataProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (_phase) {
            _DisplayPhase.showing => 'Share QR Code',
            _DisplayPhase.verifying => 'Verify Connection',
            _DisplayPhase.connected => 'Connected',
          },
        ),
        actions: [
          if (_phase == _DisplayPhase.showing)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Regenerate',
              onPressed: () => ref.invalidate(qrPairingDataProvider),
            ),
        ],
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (_phase) {
            _DisplayPhase.showing => qrDataAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => _ErrorView(error: e.toString()),
                data: (qrData) {
                  _extractQrToken(qrData);
                  return _QrCodeView(
                    qrData: qrData,
                    pulseController: _pulseController,
                    theme: theme,
                    ref: ref,
                  );
                },
              ),
            _DisplayPhase.verifying => _VerifyView(
                peerName: _peerName ?? 'Device',
                peerPlatform: _peerPlatform ?? 'unknown',
                verificationCode: _verificationCode ?? '0000',
                onConfirm: _confirm,
                onReject: _reject,
              ),
            _DisplayPhase.connected => _ConnectedView(
                peerName: _peerName ?? 'Device',
                peerPlatform: _peerPlatform ?? 'unknown',
                onDone: () => Navigator.of(context).pop(),
              ),
          },
        ),
      ),
    );
  }
}

// ── QR Code display (phase: showing) ─────────────────────────────────────

class _QrCodeView extends StatelessWidget {
  const _QrCodeView({
    required this.qrData,
    required this.pulseController,
    required this.theme,
    required this.ref,
  });

  final String qrData;
  final AnimationController pulseController;
  final ThemeData theme;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR code with animated pulse background.
          Stack(
            alignment: Alignment.center,
            children: [
              // Pulse rings.
              ...List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: pulseController,
                  builder: (_, __) {
                    final value =
                        ((pulseController.value + i * 0.33) % 1.0);
                    return Container(
                      width: 280 + (value * 60),
                      height: 280 + (value * 60),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryLight
                              .withAlpha((80 * (1 - value)).round()),
                          width: 2,
                        ),
                      ),
                    );
                  },
                );
              }),

              // QR code card.
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryLight.withAlpha(40),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 230,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppColors.primary,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF0D0D0D),
                  ),
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),

          // Title.
          Text(
            'Scan to Connect',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Open MX Video on the other device\nand tap "Scan QR Code"',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          // Device info chip.
          Consumer(
            builder: (context, ref, _) {
              final nameAsync = ref.watch(deviceNameProvider);
              return nameAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (name) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withAlpha(15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primaryLight.withAlpha(40)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone_android,
                          size: 16, color: AppColors.primaryLight),
                      const SizedBox(width: 8),
                      Text(
                        name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Waiting indicator.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textSecondary.withAlpha(150),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Waiting for connection...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Security note.
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withAlpha(30)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline,
                    color: AppColors.success, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Connection is encrypted end-to-end.\n'
                    'QR code refreshes automatically.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Verification code (phase: verifying) ─────────────────────────────────

class _VerifyView extends StatelessWidget {
  const _VerifyView({
    required this.peerName,
    required this.peerPlatform,
    required this.verificationCode,
    required this.onConfirm,
    required this.onReject,
  });

  final String peerName;
  final String peerPlatform;
  final String verificationCode;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
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
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Confirm this code matches\non the other device',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Verification code display.
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(8),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.primaryLight.withAlpha(40)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < verificationCode.length; i++) ...[
                  if (i == 2)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '—',
                        style: TextStyle(
                          fontSize: 28,
                          color: AppColors.textSecondary.withAlpha(100),
                        ),
                      ),
                    ),
                  Text(
                    verificationCode[i],
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Connected peer info chip.
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(15),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primaryLight.withAlpha(40)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_platformIcon(peerPlatform),
                    size: 16, color: AppColors.primaryLight),
                const SizedBox(width: 8),
                Text(
                  peerName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // Action buttons.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                onPressed: onReject,
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
                onPressed: onConfirm,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _platformIcon(String platform) => switch (platform) {
        'android' => Icons.phone_android,
        'ios' => Icons.phone_iphone,
        'windows' => Icons.laptop_windows,
        'macos' => Icons.laptop_mac,
        'linux' => Icons.computer,
        _ => Icons.devices_other,
      };
}

// ── Connected (phase: connected) ─────────────────────────────────────────

class _ConnectedView extends StatelessWidget {
  const _ConnectedView({
    required this.peerName,
    required this.peerPlatform,
    required this.onDone,
  });

  final String peerName;
  final String peerPlatform;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (_, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withAlpha(20),
              ),
              child: const Icon(Icons.check_circle,
                  color: AppColors.success, size: 56),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Securely Connected',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Peer info card.
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(8),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppColors.primaryLight.withAlpha(30)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_platformIcon(peerPlatform),
                    color: AppColors.primaryLight, size: 28),
                const SizedBox(width: 12),
                Text(
                  peerName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withAlpha(15),
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
          FilledButton(onPressed: onDone, child: const Text('Done')),
        ],
      ),
    );
  }

  IconData _platformIcon(String platform) => switch (platform) {
        'android' => Icons.phone_android,
        'ios' => Icons.phone_iphone,
        'windows' => Icons.laptop_windows,
        'macos' => Icons.laptop_mac,
        'linux' => Icons.computer,
        _ => Icons.devices_other,
      };
}

// ── Error ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
        const SizedBox(height: 12),
        Text('Failed to generate QR code:\n$error',
            textAlign: TextAlign.center),
      ],
    );
  }
}
