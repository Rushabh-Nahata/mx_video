// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CastDiscovery)
final castDiscoveryProvider = CastDiscoveryProvider._();

final class CastDiscoveryProvider
    extends $NotifierProvider<CastDiscovery, List<CastDevice>> {
  CastDiscoveryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'castDiscoveryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$castDiscoveryHash();

  @$internal
  @override
  CastDiscovery create() => CastDiscovery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CastDevice> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CastDevice>>(value),
    );
  }
}

String _$castDiscoveryHash() => r'0c89e58835cbf03a6cef798d0325ab132f520034';

abstract class _$CastDiscovery extends $Notifier<List<CastDevice>> {
  List<CastDevice> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<CastDevice>, List<CastDevice>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CastDevice>, List<CastDevice>>,
              List<CastDevice>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CastSessionState)
final castSessionStateProvider = CastSessionStateProvider._();

final class CastSessionStateProvider
    extends $NotifierProvider<CastSessionState, SessionState> {
  CastSessionStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'castSessionStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$castSessionStateHash();

  @$internal
  @override
  CastSessionState create() => CastSessionState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionState>(value),
    );
  }
}

String _$castSessionStateHash() => r'25e464b4c8d2773d61dfd6d4a6286285ff28320a';

abstract class _$CastSessionState extends $Notifier<SessionState> {
  SessionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SessionState, SessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionState, SessionState>,
              SessionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CastPosition)
final castPositionProvider = CastPositionProvider._();

final class CastPositionProvider
    extends $NotifierProvider<CastPosition, Duration> {
  CastPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'castPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$castPositionHash();

  @$internal
  @override
  CastPosition create() => CastPosition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$castPositionHash() => r'831faed8bf99739cb375cbbe25f66fe3734767b2';

abstract class _$CastPosition extends $Notifier<Duration> {
  Duration build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Duration, Duration>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Duration, Duration>,
              Duration,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CastDuration)
final castDurationProvider = CastDurationProvider._();

final class CastDurationProvider
    extends $NotifierProvider<CastDuration, Duration> {
  CastDurationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'castDurationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$castDurationHash();

  @$internal
  @override
  CastDuration create() => CastDuration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$castDurationHash() => r'c338ae1822eef7e20444b5aa57005632d56590e8';

abstract class _$CastDuration extends $Notifier<Duration> {
  Duration build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Duration, Duration>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Duration, Duration>,
              Duration,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CastDeviceName)
final castDeviceNameProvider = CastDeviceNameProvider._();

final class CastDeviceNameProvider
    extends $NotifierProvider<CastDeviceName, String?> {
  CastDeviceNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'castDeviceNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$castDeviceNameHash();

  @$internal
  @override
  CastDeviceName create() => CastDeviceName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$castDeviceNameHash() => r'c43ad0aedcd70ce992c45f90daabb13ef2b20fe9';

abstract class _$CastDeviceName extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
