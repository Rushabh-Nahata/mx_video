import '../entities/media_folder.dart';
import '../repositories/library_repository.dart';

class GetFolders {
  const GetFolders(this._repository);
  final LibraryRepository _repository;

  Stream<List<MediaFolderEntity>> call() => _repository.watchFolders();
}
