import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../data/repositories/transfer_repository_impl.dart';
import '../../data/sources/ble_discovery_source.dart';
import '../../data/sources/mdns_source.dart';
import '../../data/sources/qr_pairing_source.dart';
import '../../data/transfer_client.dart';
import '../../data/transfer_server.dart';
import '../../domain/entities/peer_device.dart';
import '../../domain/entities/transfer_job.dart';
import '../../domain/repositories/transfer_repository.dart';

part 'transfer_provider.g.dart';

// ── Singletons ───────────────────────────────────────────────────────────

@riverpod
TransferServer transferServer(Ref ref) {
  final server = TransferServer();
  ref.onDispose(server.stop);
  return server;
}

@riverpod
TransferClient transferClient(Ref ref) {
  final client = TransferClient();
  ref.onDispose(client.dispose);
  return client;
}

@riverpod
MdnsSource mdnsSource(Ref ref) {
  final source = MdnsSource();
  ref.onDispose(source.dispose);
  return source;
}

@riverpod
BleDiscoverySource bleDiscoverySource(Ref ref) {
  final source = BleDiscoverySource();
  ref.onDispose(source.dispose);
  return source;
}

@riverpod
QrPairingSource qrPairingSource(Ref ref) {
  return QrPairingSource();
}

@riverpod
Future<String> deviceName(Ref ref) async {
  final info = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      return android.model;
    } else if (Platform.isIOS) {
      final ios = await info.iosInfo;
      return ios.name;
    } else if (Platform.isWindows) {
      final windows = await info.windowsInfo;
      return windows.computerName;
    } else if (Platform.isMacOS) {
      final macos = await info.macOsInfo;
      return macos.computerName;
    } else if (Platform.isLinux) {
      final linux = await info.linuxInfo;
      return linux.prettyName;
    }
  } catch (_) {}
  return 'MX Video Device';
}

@riverpod
String currentPlatform(Ref ref) {
  if (Platform.isAndroid) return 'android';
  if (Platform.isIOS) return 'ios';
  if (Platform.isWindows) return 'windows';
  if (Platform.isMacOS) return 'macos';
  if (Platform.isLinux) return 'linux';
  return 'unknown';
}

// ── Repository ───────────────────────────────────────────────────────────

@riverpod
Future<TransferRepository> transferRepository(Ref ref) async {
  final name = await ref.watch(deviceNameProvider.future);
  final platform = ref.watch(currentPlatformProvider);

  return TransferRepositoryImpl(
    dao: ref.watch(transferDaoProvider),
    mdns: ref.watch(mdnsSourceProvider),
    ble: ref.watch(bleDiscoverySourceProvider),
    qr: ref.watch(qrPairingSourceProvider),
    server: ref.watch(transferServerProvider),
    client: ref.watch(transferClientProvider),
    deviceName: name,
    platform: platform,
    mediaDao: ref.watch(appDatabaseProvider),
    onIncomingTransfer: () {
      final nav = rootNavigatorKey.currentState;
      if (nav != null) {
        final router = GoRouter.of(nav.context);
        final location = router.routeInformationProvider.value.uri.path;
        if (location != RouteNames.transferProgress) {
          router.push(RouteNames.transferProgress);
        }
      }
    },
  );
}

// ── Discovery ────────────────────────────────────────────────────────────

@riverpod
Stream<List<PeerDevice>> peers(Ref ref) async* {
  final repo = await ref.watch(transferRepositoryProvider.future);
  yield* repo.discoverPeers();
}

// ── Transfer Jobs ────────────────────────────────────────────────────────

@riverpod
Stream<List<TransferJobEntity>> transferJobs(Ref ref) async* {
  final repo = await ref.watch(transferRepositoryProvider.future);
  yield* repo.watchJobs();
}

// ── QR Pairing ───────────────────────────────────────────────────────────

@riverpod
Future<String> qrPairingData(Ref ref) async {
  final repo = await ref.watch(transferRepositoryProvider.future);
  final qr = ref.watch(qrPairingSourceProvider);
  final data = await repo.generatePairingInfo();
  return qr.encodePairingData(data);
}

// ── Encryption preference ────────────────────────────────────────────────

@riverpod
class EncryptionPreference extends _$EncryptionPreference {
  @override
  bool build() => true; // encryption on by default

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

// ── Transfer Manager ─────────────────────────────────────────────────────

@riverpod
class TransferManager extends _$TransferManager {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Start the transfer server and begin advertising.
  Future<void> startListening() async {
    final repo = await ref.read(transferRepositoryProvider.future);
    await repo.startServer();
    await repo.startAdvertising();
  }

  /// Stop the transfer server and advertising.
  Future<void> stopListening() async {
    final repo = await ref.read(transferRepositoryProvider.future);
    await repo.stopAdvertising();
    await repo.stopServer();
  }

  /// Send a single file to a peer.
  Future<void> sendFile(PeerDevice peer, String filePath) async {
    state = const AsyncLoading();
    try {
      final repo = await ref.read(transferRepositoryProvider.future);
      await repo.sendFile(peer, filePath);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Send multiple files to a peer.
  Future<void> sendFiles(PeerDevice peer, List<String> filePaths) async {
    state = const AsyncLoading();
    try {
      final repo = await ref.read(transferRepositoryProvider.future);
      await repo.sendFiles(peer, filePaths);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Connect to a peer from QR scan data.
  ///
  /// Performs the full pairing handshake:
  ///   1. Decode QR → extract peer info
  ///   2. HTTP POST /pair → exchange device info, get session token
  ///   3. Return connected PeerDevice
  Future<PeerDevice?> connectFromQr(String qrData) async {
    final qrSource = ref.read(qrPairingSourceProvider);
    final data = qrSource.decodePairingData(qrData);
    if (data == null) return null;

    // Validate QR data.
    if (qrSource.isExpired(data)) return null;

    final repo = await ref.read(transferRepositoryProvider.future);

    // Start our server so the peer can connect back.
    await repo.startServer();

    // Connect to the peer.
    final peer = await repo.connectFromQr(data);

    // Perform the HTTP pairing handshake.
    final client = ref.read(transferClientProvider);
    final name = await ref.read(deviceNameProvider.future);
    final platform = ref.read(currentPlatformProvider);

    try {
      final token = await client.pair(
        peer: peer,
        deviceName: name,
        platform: platform,
      );

      // Return peer with the session token.
      return peer.copyWith(sessionToken: token);
    } catch (_) {
      return null;
    }
  }

  Future<void> pauseJob(int jobId) async {
    final repo = await ref.read(transferRepositoryProvider.future);
    await repo.pauseJob(jobId);
  }

  Future<void> cancelJob(int jobId) async {
    final repo = await ref.read(transferRepositoryProvider.future);
    await repo.cancelJob(jobId);
  }

  Future<void> retryJob(int jobId) async {
    final repo = await ref.read(transferRepositoryProvider.future);
    await repo.retryJob(jobId);
  }
}
