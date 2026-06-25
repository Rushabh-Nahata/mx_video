import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/browser_repository_impl.dart';
import '../../data/sources/file_system_source.dart';
import '../../domain/entities/file_node.dart';

import '../../domain/repositories/browser_repository.dart';
import '../../domain/usecases/list_directory.dart';
import '../../domain/usecases/search_files.dart';

part 'browser_provider.freezed.dart';
part 'browser_provider.g.dart';

@freezed
abstract class BrowserState with _$BrowserState {
  const factory BrowserState({
    @Default([]) List<String> pathStack,
    @Default([]) List<Object> entries, // FolderNode | FileNode
    @Default(false) bool isLoading,
    @Default('') String searchQuery,
    @Default([]) List<FileNode> searchResults,
    String? error,
  }) = _BrowserState;

  const BrowserState._();

  String get currentPath => pathStack.isEmpty ? '' : pathStack.last;
  bool get isSearching => searchQuery.isNotEmpty;
  bool get canGoBack => pathStack.length > 1;
}

@riverpod
BrowserRepository browserRepository(Ref ref) =>
    BrowserRepositoryImpl(FileSystemSource());

@riverpod
class Browser extends _$Browser {
  late BrowserRepository _repo;

  @override
  BrowserState build() {
    _repo = ref.watch(browserRepositoryProvider);
    _init();
    return const BrowserState(isLoading: true);
  }

  Future<void> _init() async {
    final root = await _repo.getStorageRootPath();
    await navigateTo(root, clearStack: true);
  }

  Future<void> navigateTo(String path, {bool clearStack = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final entries = await ListDirectory(_repo).call(path);
      final newStack = clearStack
          ? [path]
          : [...state.pathStack, path];
      state = state.copyWith(
        pathStack: newStack,
        entries: entries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> goBack() async {
    if (!state.canGoBack) return;
    final newStack = state.pathStack.sublist(0, state.pathStack.length - 1);
    final path = newStack.last;
    state = state.copyWith(pathStack: newStack, isLoading: true);
    final entries = await ListDirectory(_repo).call(path);
    state = state.copyWith(entries: entries, isLoading: false);
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchQuery: '', searchResults: []);
      return;
    }
    state = state.copyWith(searchQuery: query, isLoading: true);
    final results = await SearchFiles(_repo).call(query, state.currentPath);
    state = state.copyWith(searchResults: results, isLoading: false);
  }
}
