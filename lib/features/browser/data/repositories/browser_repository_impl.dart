import '../../domain/entities/file_node.dart';
import '../../domain/entities/folder_node.dart';
import '../../domain/repositories/browser_repository.dart';
import '../sources/file_system_source.dart';

class BrowserRepositoryImpl implements BrowserRepository {
  BrowserRepositoryImpl(this._source);
  final FileSystemSource _source;

  @override
  Future<String> getStorageRootPath() => _source.getStorageRoot();

  @override
  Future<List<FolderNode>> listSubdirectories(String path) =>
      _source.listDirectories(path);

  @override
  Future<List<FileNode>> listFiles(String path) => _source.listFiles(path);

  @override
  Future<List<Object>> listAll(String path) async {
    final dirs = await _source.listDirectories(path);
    final files = await _source.listFiles(path);
    return [...dirs, ...files];
  }

  @override
  Future<List<FileNode>> search(String query, String rootPath) =>
      _source.search(query, rootPath);
}
