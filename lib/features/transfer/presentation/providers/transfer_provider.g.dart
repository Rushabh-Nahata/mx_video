// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transferServer)
final transferServerProvider = TransferServerProvider._();

final class TransferServerProvider
    extends $FunctionalProvider<TransferServer, TransferServer, TransferServer>
    with $Provider<TransferServer> {
  TransferServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transferServerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transferServerHash();

  @$internal
  @override
  $ProviderElement<TransferServer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TransferServer create(Ref ref) {
    return transferServer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransferServer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransferServer>(value),
    );
  }
}

String _$transferServerHash() => r'e24a15f7b962429db389c2d6f9eb05a08a3c5423';

@ProviderFor(transferClient)
final transferClientProvider = TransferClientProvider._();

final class TransferClientProvider
    extends $FunctionalProvider<TransferClient, TransferClient, TransferClient>
    with $Provider<TransferClient> {
  TransferClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transferClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transferClientHash();

  @$internal
  @override
  $ProviderElement<TransferClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TransferClient create(Ref ref) {
    return transferClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransferClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransferClient>(value),
    );
  }
}

String _$transferClientHash() => r'f9af5e7ba5ec6188b6e88b67fba3d4536e06a092';

@ProviderFor(mdnsSource)
final mdnsSourceProvider = MdnsSourceProvider._();

final class MdnsSourceProvider
    extends $FunctionalProvider<MdnsSource, MdnsSource, MdnsSource>
    with $Provider<MdnsSource> {
  MdnsSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mdnsSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mdnsSourceHash();

  @$internal
  @override
  $ProviderElement<MdnsSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MdnsSource create(Ref ref) {
    return mdnsSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MdnsSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MdnsSource>(value),
    );
  }
}

String _$mdnsSourceHash() => r'69c67021bddbe214ad08a8dd1e7c59d2c3b7bff0';

@ProviderFor(bleDiscoverySource)
final bleDiscoverySourceProvider = BleDiscoverySourceProvider._();

final class BleDiscoverySourceProvider
    extends
        $FunctionalProvider<
          BleDiscoverySource,
          BleDiscoverySource,
          BleDiscoverySource
        >
    with $Provider<BleDiscoverySource> {
  BleDiscoverySourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bleDiscoverySourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bleDiscoverySourceHash();

  @$internal
  @override
  $ProviderElement<BleDiscoverySource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BleDiscoverySource create(Ref ref) {
    return bleDiscoverySource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BleDiscoverySource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BleDiscoverySource>(value),
    );
  }
}

String _$bleDiscoverySourceHash() =>
    r'2d9e2710f9dddb664b8eafc52a7b3da183705605';

@ProviderFor(qrPairingSource)
final qrPairingSourceProvider = QrPairingSourceProvider._();

final class QrPairingSourceProvider
    extends
        $FunctionalProvider<QrPairingSource, QrPairingSource, QrPairingSource>
    with $Provider<QrPairingSource> {
  QrPairingSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qrPairingSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qrPairingSourceHash();

  @$internal
  @override
  $ProviderElement<QrPairingSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QrPairingSource create(Ref ref) {
    return qrPairingSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QrPairingSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QrPairingSource>(value),
    );
  }
}

String _$qrPairingSourceHash() => r'e5026502338863dce516a342702bf46096fb2d19';

@ProviderFor(deviceName)
final deviceNameProvider = DeviceNameProvider._();

final class DeviceNameProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  DeviceNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceNameHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return deviceName(ref);
  }
}

String _$deviceNameHash() => r'a691490f9a30d776d01b03c9b7d6ff88b35c2ac2';

@ProviderFor(currentPlatform)
final currentPlatformProvider = CurrentPlatformProvider._();

final class CurrentPlatformProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  CurrentPlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPlatformProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPlatformHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentPlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentPlatformHash() => r'd7c99d3bf67fe5a31e2ee814f9a407dc77125c94';

@ProviderFor(transferRepository)
final transferRepositoryProvider = TransferRepositoryProvider._();

final class TransferRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<TransferRepository>,
          TransferRepository,
          FutureOr<TransferRepository>
        >
    with
        $FutureModifier<TransferRepository>,
        $FutureProvider<TransferRepository> {
  TransferRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transferRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transferRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<TransferRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TransferRepository> create(Ref ref) {
    return transferRepository(ref);
  }
}

String _$transferRepositoryHash() =>
    r'f85088fe8bd0740f8dbe5671405d3656c3a4ecdf';

@ProviderFor(peers)
final peersProvider = PeersProvider._();

final class PeersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PeerDevice>>,
          List<PeerDevice>,
          Stream<List<PeerDevice>>
        >
    with $FutureModifier<List<PeerDevice>>, $StreamProvider<List<PeerDevice>> {
  PeersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'peersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$peersHash();

  @$internal
  @override
  $StreamProviderElement<List<PeerDevice>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PeerDevice>> create(Ref ref) {
    return peers(ref);
  }
}

String _$peersHash() => r'566e1737e25d696828086b6ca2ae4a9682c24b3b';

@ProviderFor(transferJobs)
final transferJobsProvider = TransferJobsProvider._();

final class TransferJobsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransferJobEntity>>,
          List<TransferJobEntity>,
          Stream<List<TransferJobEntity>>
        >
    with
        $FutureModifier<List<TransferJobEntity>>,
        $StreamProvider<List<TransferJobEntity>> {
  TransferJobsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transferJobsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transferJobsHash();

  @$internal
  @override
  $StreamProviderElement<List<TransferJobEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransferJobEntity>> create(Ref ref) {
    return transferJobs(ref);
  }
}

String _$transferJobsHash() => r'6237ce10550809cc2e763d519816146a942cc241';

@ProviderFor(qrPairingData)
final qrPairingDataProvider = QrPairingDataProvider._();

final class QrPairingDataProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  QrPairingDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qrPairingDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qrPairingDataHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return qrPairingData(ref);
  }
}

String _$qrPairingDataHash() => r'0c42021990bb4c70a8a8dc716a4fe2e6f269ddd1';

@ProviderFor(EncryptionPreference)
final encryptionPreferenceProvider = EncryptionPreferenceProvider._();

final class EncryptionPreferenceProvider
    extends $NotifierProvider<EncryptionPreference, bool> {
  EncryptionPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'encryptionPreferenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$encryptionPreferenceHash();

  @$internal
  @override
  EncryptionPreference create() => EncryptionPreference();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$encryptionPreferenceHash() =>
    r'7344aa1104cc702d584f9841e9f27951312e8c30';

abstract class _$EncryptionPreference extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(TransferManager)
final transferManagerProvider = TransferManagerProvider._();

final class TransferManagerProvider
    extends $NotifierProvider<TransferManager, AsyncValue<void>> {
  TransferManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transferManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transferManagerHash();

  @$internal
  @override
  TransferManager create() => TransferManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$transferManagerHash() => r'a7c875e0bc0f8c225c419f6fbb147f56c904e64b';

abstract class _$TransferManager extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
