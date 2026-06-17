import '../entities/media_file.dart';
import '../repositories/library_repository.dart';

class GetRecents {
  const GetRecents(this._repository);
  final LibraryRepository _repository;

  Stream<List<MediaFileEntity>> call({int limit = 50}) =>
      _repository.watchRecents(limit: limit);
}
