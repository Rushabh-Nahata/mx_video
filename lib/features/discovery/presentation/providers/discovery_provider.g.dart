// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(discoveryRepository)
final discoveryRepositoryProvider = DiscoveryRepositoryProvider._();

final class DiscoveryRepositoryProvider
    extends
        $FunctionalProvider<
          DiscoveryRepository,
          DiscoveryRepository,
          DiscoveryRepository
        >
    with $Provider<DiscoveryRepository> {
  DiscoveryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoveryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiscoveryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiscoveryRepository create(Ref ref) {
    return discoveryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoveryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoveryRepository>(value),
    );
  }
}

String _$discoveryRepositoryHash() =>
    r'39f0feeba423337d9f92e99bdf098a3bd5cae3ef';

@ProviderFor(DeviceDiscovery)
final deviceDiscoveryProvider = DeviceDiscoveryProvider._();

final class DeviceDiscoveryProvider
    extends $NotifierProvider<DeviceDiscovery, DiscoveryState> {
  DeviceDiscoveryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceDiscoveryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceDiscoveryHash();

  @$internal
  @override
  DeviceDiscovery create() => DeviceDiscovery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoveryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoveryState>(value),
    );
  }
}

String _$deviceDiscoveryHash() => r'fe22c357ae5f98b3f053180087a7bd5562f29035';

abstract class _$DeviceDiscovery extends $Notifier<DiscoveryState> {
  DiscoveryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DiscoveryState, DiscoveryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoveryState, DiscoveryState>,
              DiscoveryState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
