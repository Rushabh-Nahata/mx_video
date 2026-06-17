import 'package:drift/drift.dart';

/// Drift table definition for indexed media files (video + audio).
class MediaFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get absolutePath => text().unique()();
  TextColumn get name => text()();
  TextColumn get extension => text()();
  IntColumn get sizeBytes => integer()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  IntColumn get folderId => integer().nullable().references(MediaFolders, #id)();
  IntColumn get lastPlayedAt => integer().nullable()();
  IntColumn get playPositionMs => integer().withDefault(const Constant(0))();
  IntColumn get playCount => integer().withDefault(const Constant(0))();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
  IntColumn get scannedAt => integer()();
}

/// Drift table definition for media folders discovered during scan.
class MediaFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get absolutePath => text().unique()();
  TextColumn get name => text()();
  IntColumn get parentId => integer().nullable().references(MediaFolders, #id)();
  TextColumn get thumbnailPath => text().nullable()();
  IntColumn get videoCount => integer().withDefault(const Constant(0))();
  IntColumn get audioCount => integer().withDefault(const Constant(0))();
  BoolColumn get isWatched => boolean().withDefault(const Constant(false))();
}
