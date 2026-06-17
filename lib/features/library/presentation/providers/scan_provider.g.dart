// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes [ScanState] to the UI and drives [MediaScannerService.scan].
///
/// The notifier owns the scan lifecycle:
///   - [startScan] kicks off a new scan (cancels any in-progress scan).
///   - State flows through all [ScanPhase] values and settles on
///     [ScanPhase.complete] or [ScanPhase.error].
///   - The UI can cancel via [cancel] (stops consuming the stream; the
///     current DB chunk finishes, then no more chunks are written).

@ProviderFor(ScanNotifier)
final scanProvider = ScanNotifierProvider._();

/// Exposes [ScanState] to the UI and drives [MediaScannerService.scan].
///
/// The notifier owns the scan lifecycle:
///   - [startScan] kicks off a new scan (cancels any in-progress scan).
///   - State flows through all [ScanPhase] values and settles on
///     [ScanPhase.complete] or [ScanPhase.error].
///   - The UI can cancel via [cancel] (stops consuming the stream; the
///     current DB chunk finishes, then no more chunks are written).
final class ScanNotifierProvider
    extends $NotifierProvider<ScanNotifier, ScanState> {
  /// Exposes [ScanState] to the UI and drives [MediaScannerService.scan].
  ///
  /// The notifier owns the scan lifecycle:
  ///   - [startScan] kicks off a new scan (cancels any in-progress scan).
  ///   - State flows through all [ScanPhase] values and settles on
  ///     [ScanPhase.complete] or [ScanPhase.error].
  ///   - The UI can cancel via [cancel] (stops consuming the stream; the
  ///     current DB chunk finishes, then no more chunks are written).
  ScanNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanNotifierHash();

  @$internal
  @override
  ScanNotifier create() => ScanNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanState>(value),
    );
  }
}

String _$scanNotifierHash() => r'0e33191c0630c6315965aa84a147db607145057a';

/// Exposes [ScanState] to the UI and drives [MediaScannerService.scan].
///
/// The notifier owns the scan lifecycle:
///   - [startScan] kicks off a new scan (cancels any in-progress scan).
///   - State flows through all [ScanPhase] values and settles on
///     [ScanPhase.complete] or [ScanPhase.error].
///   - The UI can cancel via [cancel] (stops consuming the stream; the
///     current DB chunk finishes, then no more chunks are written).

abstract class _$ScanNotifier extends $Notifier<ScanState> {
  ScanState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ScanState, ScanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScanState, ScanState>,
              ScanState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
