// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statusAvailable)
final statusAvailableProvider = StatusAvailableProvider._();

final class StatusAvailableProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  StatusAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statusAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statusAvailableHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return statusAvailable(ref);
  }
}

String _$statusAvailableHash() => r'c563d85bd49e7e17415668b71ba1eda43ddc5902';

@ProviderFor(RecentStatuses)
final recentStatusesProvider = RecentStatusesProvider._();

final class RecentStatusesProvider
    extends $AsyncNotifierProvider<RecentStatuses, List<StatusItem>> {
  RecentStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentStatusesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentStatusesHash();

  @$internal
  @override
  RecentStatuses create() => RecentStatuses();
}

String _$recentStatusesHash() => r'11f6a5ecadef834e42fdfe7ab1a54ca15a66556a';

abstract class _$RecentStatuses extends $AsyncNotifier<List<StatusItem>> {
  FutureOr<List<StatusItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<StatusItem>>, List<StatusItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<StatusItem>>, List<StatusItem>>,
              AsyncValue<List<StatusItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SavedStatuses)
final savedStatusesProvider = SavedStatusesProvider._();

final class SavedStatusesProvider
    extends $AsyncNotifierProvider<SavedStatuses, List<StatusItem>> {
  SavedStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedStatusesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedStatusesHash();

  @$internal
  @override
  SavedStatuses create() => SavedStatuses();
}

String _$savedStatusesHash() => r'4e0147c44419d05a8578cc223bf2c9fb9458cf04';

abstract class _$SavedStatuses extends $AsyncNotifier<List<StatusItem>> {
  FutureOr<List<StatusItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<StatusItem>>, List<StatusItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<StatusItem>>, List<StatusItem>>,
              AsyncValue<List<StatusItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(StatusFilter)
final statusFilterProvider = StatusFilterProvider._();

final class StatusFilterProvider
    extends $NotifierProvider<StatusFilter, StatusFilterType> {
  StatusFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statusFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statusFilterHash();

  @$internal
  @override
  StatusFilter create() => StatusFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatusFilterType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatusFilterType>(value),
    );
  }
}

String _$statusFilterHash() => r'e3ec8be3c1dbc6acd8b71b6859be6a757a17543e';

abstract class _$StatusFilter extends $Notifier<StatusFilterType> {
  StatusFilterType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StatusFilterType, StatusFilterType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatusFilterType, StatusFilterType>,
              StatusFilterType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
