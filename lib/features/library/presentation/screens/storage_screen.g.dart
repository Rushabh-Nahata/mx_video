// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storageInfo)
final storageInfoProvider = StorageInfoProvider._();

final class StorageInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<StorageInfo>,
          StorageInfo,
          FutureOr<StorageInfo>
        >
    with $FutureModifier<StorageInfo>, $FutureProvider<StorageInfo> {
  StorageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageInfoHash();

  @$internal
  @override
  $FutureProviderElement<StorageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StorageInfo> create(Ref ref) {
    return storageInfo(ref);
  }
}

String _$storageInfoHash() => r'5b1ebf36c55cafb124a5ca9eadbec1afd4714644';
