import '../entities/file_node.dart';
import '../repositories/browser_repository.dart';

class SearchFiles {
  const SearchFiles(this._repository);
  final BrowserRepository _repository;

  Future<List<FileNode>> call(String query, String rootPath) =>
      _repository.search(query, rootPath);
}
