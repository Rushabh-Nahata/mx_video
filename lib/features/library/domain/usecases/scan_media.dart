import '../entities/scan_state.dart';
import '../repositories/library_repository.dart';

class ScanMedia {
  const ScanMedia(this._repository);
  final LibraryRepository _repository;

  Stream<ScanState> call({List<String>? rootPaths}) =>
      _repository.scan(rootPaths: rootPaths);
}
