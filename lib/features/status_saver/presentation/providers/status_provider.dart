import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/status_repository.dart';
import '../../domain/entities/status_item.dart';

part 'status_provider.g.dart';

final statusRepositoryProvider = Provider<StatusRepository>(
  (ref) => StatusRepository(),
);

@riverpod
Future<bool> statusAvailable(Ref ref) {
  return ref.watch(statusRepositoryProvider).isAvailable;
}

@riverpod
class RecentStatuses extends _$RecentStatuses {
  @override
  Future<List<StatusItem>> build() {
    return ref.watch(statusRepositoryProvider).getRecentStatuses();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(statusRepositoryProvider).getRecentStatuses(),
    );
  }

  Future<void> saveStatus(String path) async {
    final repo = ref.read(statusRepositoryProvider);
    await repo.saveStatus(path);
    // Refresh both tabs
    ref.invalidateSelf();
    ref.invalidate(savedStatusesProvider);
  }

  Future<void> saveAll(List<String> paths) async {
    final repo = ref.read(statusRepositoryProvider);
    for (final path in paths) {
      await repo.saveStatus(path);
    }
    ref.invalidateSelf();
    ref.invalidate(savedStatusesProvider);
  }
}

@riverpod
class SavedStatuses extends _$SavedStatuses {
  @override
  Future<List<StatusItem>> build() {
    return ref.watch(statusRepositoryProvider).getSavedStatuses();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(statusRepositoryProvider).getSavedStatuses(),
    );
  }

  Future<void> deleteStatus(String path) async {
    final repo = ref.read(statusRepositoryProvider);
    await repo.deleteSavedStatus(path);
    ref.invalidateSelf();
    ref.invalidate(recentStatusesProvider);
  }
}

@riverpod
class StatusFilter extends _$StatusFilter {
  @override
  StatusFilterType build() => StatusFilterType.all;

  void set(StatusFilterType filter) => state = filter;
}

enum StatusFilterType { all, images, videos }

Future<void> shareStatusFiles(List<String> paths) async {
  final xFiles = paths.map((p) => XFile(p)).toList();
  await SharePlus.instance.share(ShareParams(files: xFiles));
}
