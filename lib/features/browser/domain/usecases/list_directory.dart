import '../repositories/browser_repository.dart';

class ListDirectory {
  const ListDirectory(this._repository);
  final BrowserRepository _repository;

  Future<List<Object>> call(String path) => _repository.listAll(path);
}
