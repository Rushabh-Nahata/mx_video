// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persists and exposes the current [ThemeMode].
/// Defaults to [ThemeMode.dark] on first launch.

@ProviderFor(ThemeMode_)
final themeMode_Provider = ThemeMode_Provider._();

/// Persists and exposes the current [ThemeMode].
/// Defaults to [ThemeMode.dark] on first launch.
final class ThemeMode_Provider
    extends $NotifierProvider<ThemeMode_, ThemeMode> {
  /// Persists and exposes the current [ThemeMode].
  /// Defaults to [ThemeMode.dark] on first launch.
  ThemeMode_Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeMode_Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeMode_Hash();

  @$internal
  @override
  ThemeMode_ create() => ThemeMode_();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeMode_Hash() => r'083f4a70b984602bf3d29029ff3967523d734b64';

/// Persists and exposes the current [ThemeMode].
/// Defaults to [ThemeMode.dark] on first launch.

abstract class _$ThemeMode_ extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Convenience provider that exposes the current [ThemeMode] value.

@ProviderFor(themeModeValue)
final themeModeValueProvider = ThemeModeValueProvider._();

/// Convenience provider that exposes the current [ThemeMode] value.

final class ThemeModeValueProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  /// Convenience provider that exposes the current [ThemeMode] value.
  ThemeModeValueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeValueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeValueHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return themeModeValue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeValueHash() => r'aeeb157e428507e558df97b32eb58d83a933a1a2';
