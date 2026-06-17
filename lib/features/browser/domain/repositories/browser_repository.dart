import '../entities/file_node.dart';
import '../entities/folder_node.dart';

abstract interface class BrowserRepository {
  Future<List<FolderNode>> listSubdirectories(String path);
  Future<List<FileNode>> listFiles(String path);
  Future<List<Object>> listAll(String path); // FolderNode | FileNode
  Future<List<FileNode>> search(String query, String rootPath);
  Future<String> getStorageRootPath();
}
