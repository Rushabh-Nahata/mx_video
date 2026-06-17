// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryRepository)
final libraryRepositoryProvider = LibraryRepositoryProvider._();

final class LibraryRepositoryProvider
    extends
        $FunctionalProvider<
          LibraryRepository,
          LibraryRepository,
          LibraryRepository
        >
    with $Provider<LibraryRepository> {
  LibraryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryRepositoryHash();

  @$internal
  @override
  $ProviderElement<LibraryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LibraryRepository create(Ref ref) {
    return libraryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryRepository>(value),
    );
  }
}

String _$libraryRepositoryHash() => r'b9aef59083d476418346fe1f264b43689d470c5f';

@ProviderFor(FolderSortOrder)
final folderSortOrderProvider = FolderSortOrderProvider._();

final class FolderSortOrderProvider
    extends $NotifierProvider<FolderSortOrder, SortOrder> {
  FolderSortOrderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderSortOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderSortOrderHash();

  @$internal
  @override
  FolderSortOrder create() => FolderSortOrder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortOrder>(value),
    );
  }
}

String _$folderSortOrderHash() => r'7e1b79e76bc6551db54737f13f8f3bf2200f29fa';

abstract class _$FolderSortOrder extends $Notifier<SortOrder> {
  SortOrder build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SortOrder, SortOrder>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortOrder, SortOrder>,
              SortOrder,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'a74fdf04dbf795b3f9090a7307b574a8bff68199';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(folders)
final foldersProvider = FoldersProvider._();

final class FoldersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFolderEntity>>,
          List<MediaFolderEntity>,
          Stream<List<MediaFolderEntity>>
        >
    with
        $FutureModifier<List<MediaFolderEntity>>,
        $StreamProvider<List<MediaFolderEntity>> {
  FoldersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foldersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foldersHash();

  @$internal
  @override
  $StreamProviderElement<List<MediaFolderEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MediaFolderEntity>> create(Ref ref) {
    return folders(ref);
  }
}

String _$foldersHash() => r'dd2b72ce2a4ddafd65cd44df89546b68f8a6cccb';

@ProviderFor(filesInFolder)
final filesInFolderProvider = FilesInFolderFamily._();

final class FilesInFolderProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFileEntity>>,
          List<MediaFileEntity>,
          Stream<List<MediaFileEntity>>
        >
    with
        $FutureModifier<List<MediaFileEntity>>,
        $StreamProvider<List<MediaFileEntity>> {
  FilesInFolderProvider._({
    required FilesInFolderFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'filesInFolderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filesInFolderHash();

  @override
  String toString() {
    return r'filesInFolderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MediaFileEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MediaFileEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return filesInFolder(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FilesInFolderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filesInFolderHash() => r'd5e3e7f26f70bb1f8f9591458f1214ce4193a957';

final class FilesInFolderFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MediaFileEntity>>, int> {
  FilesInFolderFamily._()
    : super(
        retry: null,
        name: r'filesInFolderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilesInFolderProvider call(int folderId) =>
      FilesInFolderProvider._(argument: folderId, from: this);

  @override
  String toString() => r'filesInFolderProvider';
}

@ProviderFor(recents)
final recentsProvider = RecentsProvider._();

final class RecentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFileEntity>>,
          List<MediaFileEntity>,
          Stream<List<MediaFileEntity>>
        >
    with
        $FutureModifier<List<MediaFileEntity>>,
        $StreamProvider<List<MediaFileEntity>> {
  RecentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentsHash();

  @$internal
  @override
  $StreamProviderElement<List<MediaFileEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MediaFileEntity>> create(Ref ref) {
    return recents(ref);
  }
}

String _$recentsHash() => r'd1f94fdef1664f54828b572f630e27bad8e48fe7';

@ProviderFor(favourites)
final favouritesProvider = FavouritesProvider._();

final class FavouritesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFileEntity>>,
          List<MediaFileEntity>,
          Stream<List<MediaFileEntity>>
        >
    with
        $FutureModifier<List<MediaFileEntity>>,
        $StreamProvider<List<MediaFileEntity>> {
  FavouritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favouritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favouritesHash();

  @$internal
  @override
  $StreamProviderElement<List<MediaFileEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MediaFileEntity>> create(Ref ref) {
    return favourites(ref);
  }
}

String _$favouritesHash() => r'f96969221777d66c445c5d490970f6fc9fd4dbab';

@ProviderFor(allFiles)
final allFilesProvider = AllFilesProvider._();

final class AllFilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFileEntity>>,
          List<MediaFileEntity>,
          Stream<List<MediaFileEntity>>
        >
    with
        $FutureModifier<List<MediaFileEntity>>,
        $StreamProvider<List<MediaFileEntity>> {
  AllFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allFilesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allFilesHash();

  @$internal
  @override
  $StreamProviderElement<List<MediaFileEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MediaFileEntity>> create(Ref ref) {
    return allFiles(ref);
  }
}

String _$allFilesHash() => r'c1b1ad8764956c9ba351cee74e7106129aead487';

@ProviderFor(SortedFilesInFolder)
final sortedFilesInFolderProvider = SortedFilesInFolderFamily._();

final class SortedFilesInFolderProvider
    extends
        $NotifierProvider<
          SortedFilesInFolder,
          AsyncValue<List<MediaFileEntity>>
        > {
  SortedFilesInFolderProvider._({
    required SortedFilesInFolderFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'sortedFilesInFolderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sortedFilesInFolderHash();

  @override
  String toString() {
    return r'sortedFilesInFolderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SortedFilesInFolder create() => SortedFilesInFolder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<MediaFileEntity>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<MediaFileEntity>>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SortedFilesInFolderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sortedFilesInFolderHash() =>
    r'ec574c5a92820b002721bca57f9eedb2d74f2795';

final class SortedFilesInFolderFamily extends $Family
    with
        $ClassFamilyOverride<
          SortedFilesInFolder,
          AsyncValue<List<MediaFileEntity>>,
          AsyncValue<List<MediaFileEntity>>,
          AsyncValue<List<MediaFileEntity>>,
          int
        > {
  SortedFilesInFolderFamily._()
    : super(
        retry: null,
        name: r'sortedFilesInFolderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SortedFilesInFolderProvider call(int folderId) =>
      SortedFilesInFolderProvider._(argument: folderId, from: this);

  @override
  String toString() => r'sortedFilesInFolderProvider';
}

abstract class _$SortedFilesInFolder
    extends $Notifier<AsyncValue<List<MediaFileEntity>>> {
  late final _$args = ref.$arg as int;
  int get folderId => _$args;

  AsyncValue<List<MediaFileEntity>> build(int folderId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MediaFileEntity>>,
              AsyncValue<List<MediaFileEntity>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MediaFileEntity>>,
                AsyncValue<List<MediaFileEntity>>
              >,
              AsyncValue<List<MediaFileEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFileEntity>>,
          List<MediaFileEntity>,
          Stream<List<MediaFileEntity>>
        >
    with
        $FutureModifier<List<MediaFileEntity>>,
        $StreamProvider<List<MediaFileEntity>> {
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $StreamProviderElement<List<MediaFileEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MediaFileEntity>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'eaf93984089c15efa529ee9bd098eedf3ebc14ff';

@ProviderFor(thumbnailPreloader)
final thumbnailPreloaderProvider = ThumbnailPreloaderProvider._();

final class ThumbnailPreloaderProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  ThumbnailPreloaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'thumbnailPreloaderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$thumbnailPreloaderHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return thumbnailPreloader(ref);
  }
}

String _$thumbnailPreloaderHash() =>
    r'931a451dc5fbb29ca23b42b2ec486536323f2c76';

@ProviderFor(FolderGridColumns)
final folderGridColumnsProvider = FolderGridColumnsProvider._();

final class FolderGridColumnsProvider
    extends $NotifierProvider<FolderGridColumns, int> {
  FolderGridColumnsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderGridColumnsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderGridColumnsHash();

  @$internal
  @override
  FolderGridColumns create() => FolderGridColumns();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$folderGridColumnsHash() => r'044e52715166858215a3a15385317f8f05f2ac62';

abstract class _$FolderGridColumns extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MediaViewColumns)
final mediaViewColumnsProvider = MediaViewColumnsProvider._();

final class MediaViewColumnsProvider
    extends $NotifierProvider<MediaViewColumns, int> {
  MediaViewColumnsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaViewColumnsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaViewColumnsHash();

  @$internal
  @override
  MediaViewColumns create() => MediaViewColumns();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$mediaViewColumnsHash() => r'd87a909a19bbbde7a5e2cab1c76b3236052b5efb';

abstract class _$MediaViewColumns extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectionNotifier)
final selectionProvider = SelectionNotifierProvider._();

final class SelectionNotifierProvider
    extends $NotifierProvider<SelectionNotifier, Set<int>> {
  SelectionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectionNotifierHash();

  @$internal
  @override
  SelectionNotifier create() => SelectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$selectionNotifierHash() => r'ddf515979bd7410f98db24a41fd0a0b9a3066791';

abstract class _$SelectionNotifier extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
