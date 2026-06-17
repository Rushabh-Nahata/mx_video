// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browser_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(browserRepository)
final browserRepositoryProvider = BrowserRepositoryProvider._();

final class BrowserRepositoryProvider
    extends
        $FunctionalProvider<
          BrowserRepository,
          BrowserRepository,
          BrowserRepository
        >
    with $Provider<BrowserRepository> {
  BrowserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browserRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browserRepositoryHash();

  @$internal
  @override
  $ProviderElement<BrowserRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrowserRepository create(Ref ref) {
    return browserRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowserRepository>(value),
    );
  }
}

String _$browserRepositoryHash() => r'47ddff278d2edd806cf140b56e6e3a74cd0dffa0';

@ProviderFor(Browser)
final browserProvider = BrowserProvider._();

final class BrowserProvider extends $NotifierProvider<Browser, BrowserState> {
  BrowserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browserHash();

  @$internal
  @override
  Browser create() => Browser();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowserState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowserState>(value),
    );
  }
}

String _$browserHash() => r'db14ed2bd05be89b5145484bd43e81d9dedb7e7f';

abstract class _$Browser extends $Notifier<BrowserState> {
  BrowserState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BrowserState, BrowserState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BrowserState, BrowserState>,
              BrowserState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
