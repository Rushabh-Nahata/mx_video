// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MediaFoldersTable extends MediaFolders
    with TableInfo<$MediaFoldersTable, MediaFolder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaFoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _absolutePathMeta = const VerificationMeta(
    'absolutePath',
  );
  @override
  late final GeneratedColumn<String> absolutePath = GeneratedColumn<String>(
    'absolute_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media_folders (id)',
    ),
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoCountMeta = const VerificationMeta(
    'videoCount',
  );
  @override
  late final GeneratedColumn<int> videoCount = GeneratedColumn<int>(
    'video_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _audioCountMeta = const VerificationMeta(
    'audioCount',
  );
  @override
  late final GeneratedColumn<int> audioCount = GeneratedColumn<int>(
    'audio_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isWatchedMeta = const VerificationMeta(
    'isWatched',
  );
  @override
  late final GeneratedColumn<bool> isWatched = GeneratedColumn<bool>(
    'is_watched',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_watched" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    absolutePath,
    name,
    parentId,
    thumbnailPath,
    videoCount,
    audioCount,
    isWatched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaFolder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('absolute_path')) {
      context.handle(
        _absolutePathMeta,
        absolutePath.isAcceptableOrUnknown(
          data['absolute_path']!,
          _absolutePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_absolutePathMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('video_count')) {
      context.handle(
        _videoCountMeta,
        videoCount.isAcceptableOrUnknown(data['video_count']!, _videoCountMeta),
      );
    }
    if (data.containsKey('audio_count')) {
      context.handle(
        _audioCountMeta,
        audioCount.isAcceptableOrUnknown(data['audio_count']!, _audioCountMeta),
      );
    }
    if (data.containsKey('is_watched')) {
      context.handle(
        _isWatchedMeta,
        isWatched.isAcceptableOrUnknown(data['is_watched']!, _isWatchedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaFolder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFolder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      absolutePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}absolute_path'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      videoCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}video_count'],
      )!,
      audioCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_count'],
      )!,
      isWatched: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_watched'],
      )!,
    );
  }

  @override
  $MediaFoldersTable createAlias(String alias) {
    return $MediaFoldersTable(attachedDatabase, alias);
  }
}

class MediaFolder extends DataClass implements Insertable<MediaFolder> {
  final int id;
  final String absolutePath;
  final String name;
  final int? parentId;
  final String? thumbnailPath;
  final int videoCount;
  final int audioCount;
  final bool isWatched;
  const MediaFolder({
    required this.id,
    required this.absolutePath,
    required this.name,
    this.parentId,
    this.thumbnailPath,
    required this.videoCount,
    required this.audioCount,
    required this.isWatched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['absolute_path'] = Variable<String>(absolutePath);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['video_count'] = Variable<int>(videoCount);
    map['audio_count'] = Variable<int>(audioCount);
    map['is_watched'] = Variable<bool>(isWatched);
    return map;
  }

  MediaFoldersCompanion toCompanion(bool nullToAbsent) {
    return MediaFoldersCompanion(
      id: Value(id),
      absolutePath: Value(absolutePath),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      videoCount: Value(videoCount),
      audioCount: Value(audioCount),
      isWatched: Value(isWatched),
    );
  }

  factory MediaFolder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFolder(
      id: serializer.fromJson<int>(json['id']),
      absolutePath: serializer.fromJson<String>(json['absolutePath']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      videoCount: serializer.fromJson<int>(json['videoCount']),
      audioCount: serializer.fromJson<int>(json['audioCount']),
      isWatched: serializer.fromJson<bool>(json['isWatched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'absolutePath': serializer.toJson<String>(absolutePath),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'videoCount': serializer.toJson<int>(videoCount),
      'audioCount': serializer.toJson<int>(audioCount),
      'isWatched': serializer.toJson<bool>(isWatched),
    };
  }

  MediaFolder copyWith({
    int? id,
    String? absolutePath,
    String? name,
    Value<int?> parentId = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    int? videoCount,
    int? audioCount,
    bool? isWatched,
  }) => MediaFolder(
    id: id ?? this.id,
    absolutePath: absolutePath ?? this.absolutePath,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    videoCount: videoCount ?? this.videoCount,
    audioCount: audioCount ?? this.audioCount,
    isWatched: isWatched ?? this.isWatched,
  );
  MediaFolder copyWithCompanion(MediaFoldersCompanion data) {
    return MediaFolder(
      id: data.id.present ? data.id.value : this.id,
      absolutePath: data.absolutePath.present
          ? data.absolutePath.value
          : this.absolutePath,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      videoCount: data.videoCount.present
          ? data.videoCount.value
          : this.videoCount,
      audioCount: data.audioCount.present
          ? data.audioCount.value
          : this.audioCount,
      isWatched: data.isWatched.present ? data.isWatched.value : this.isWatched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaFolder(')
          ..write('id: $id, ')
          ..write('absolutePath: $absolutePath, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('videoCount: $videoCount, ')
          ..write('audioCount: $audioCount, ')
          ..write('isWatched: $isWatched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    absolutePath,
    name,
    parentId,
    thumbnailPath,
    videoCount,
    audioCount,
    isWatched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaFolder &&
          other.id == this.id &&
          other.absolutePath == this.absolutePath &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.thumbnailPath == this.thumbnailPath &&
          other.videoCount == this.videoCount &&
          other.audioCount == this.audioCount &&
          other.isWatched == this.isWatched);
}

class MediaFoldersCompanion extends UpdateCompanion<MediaFolder> {
  final Value<int> id;
  final Value<String> absolutePath;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<String?> thumbnailPath;
  final Value<int> videoCount;
  final Value<int> audioCount;
  final Value<bool> isWatched;
  const MediaFoldersCompanion({
    this.id = const Value.absent(),
    this.absolutePath = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.videoCount = const Value.absent(),
    this.audioCount = const Value.absent(),
    this.isWatched = const Value.absent(),
  });
  MediaFoldersCompanion.insert({
    this.id = const Value.absent(),
    required String absolutePath,
    required String name,
    this.parentId = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.videoCount = const Value.absent(),
    this.audioCount = const Value.absent(),
    this.isWatched = const Value.absent(),
  }) : absolutePath = Value(absolutePath),
       name = Value(name);
  static Insertable<MediaFolder> custom({
    Expression<int>? id,
    Expression<String>? absolutePath,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<String>? thumbnailPath,
    Expression<int>? videoCount,
    Expression<int>? audioCount,
    Expression<bool>? isWatched,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (absolutePath != null) 'absolute_path': absolutePath,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (videoCount != null) 'video_count': videoCount,
      if (audioCount != null) 'audio_count': audioCount,
      if (isWatched != null) 'is_watched': isWatched,
    });
  }

  MediaFoldersCompanion copyWith({
    Value<int>? id,
    Value<String>? absolutePath,
    Value<String>? name,
    Value<int?>? parentId,
    Value<String?>? thumbnailPath,
    Value<int>? videoCount,
    Value<int>? audioCount,
    Value<bool>? isWatched,
  }) {
    return MediaFoldersCompanion(
      id: id ?? this.id,
      absolutePath: absolutePath ?? this.absolutePath,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      videoCount: videoCount ?? this.videoCount,
      audioCount: audioCount ?? this.audioCount,
      isWatched: isWatched ?? this.isWatched,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (absolutePath.present) {
      map['absolute_path'] = Variable<String>(absolutePath.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (videoCount.present) {
      map['video_count'] = Variable<int>(videoCount.value);
    }
    if (audioCount.present) {
      map['audio_count'] = Variable<int>(audioCount.value);
    }
    if (isWatched.present) {
      map['is_watched'] = Variable<bool>(isWatched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaFoldersCompanion(')
          ..write('id: $id, ')
          ..write('absolutePath: $absolutePath, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('videoCount: $videoCount, ')
          ..write('audioCount: $audioCount, ')
          ..write('isWatched: $isWatched')
          ..write(')'))
        .toString();
  }
}

class $MediaFilesTable extends MediaFiles
    with TableInfo<$MediaFilesTable, MediaFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _absolutePathMeta = const VerificationMeta(
    'absolutePath',
  );
  @override
  late final GeneratedColumn<String> absolutePath = GeneratedColumn<String>(
    'absolute_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extensionMeta = const VerificationMeta(
    'extension',
  );
  @override
  late final GeneratedColumn<String> extension = GeneratedColumn<String>(
    'extension',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
    'folder_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media_folders (id)',
    ),
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<int> lastPlayedAt = GeneratedColumn<int>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playPositionMsMeta = const VerificationMeta(
    'playPositionMs',
  );
  @override
  late final GeneratedColumn<int> playPositionMs = GeneratedColumn<int>(
    'play_position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _playCountMeta = const VerificationMeta(
    'playCount',
  );
  @override
  late final GeneratedColumn<int> playCount = GeneratedColumn<int>(
    'play_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFavouriteMeta = const VerificationMeta(
    'isFavourite',
  );
  @override
  late final GeneratedColumn<bool> isFavourite = GeneratedColumn<bool>(
    'is_favourite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favourite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scannedAtMeta = const VerificationMeta(
    'scannedAt',
  );
  @override
  late final GeneratedColumn<int> scannedAt = GeneratedColumn<int>(
    'scanned_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    absolutePath,
    name,
    extension,
    sizeBytes,
    durationMs,
    width,
    height,
    thumbnailPath,
    folderId,
    lastPlayedAt,
    playPositionMs,
    playCount,
    isFavourite,
    scannedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('absolute_path')) {
      context.handle(
        _absolutePathMeta,
        absolutePath.isAcceptableOrUnknown(
          data['absolute_path']!,
          _absolutePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_absolutePathMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('extension')) {
      context.handle(
        _extensionMeta,
        extension.isAcceptableOrUnknown(data['extension']!, _extensionMeta),
      );
    } else if (isInserting) {
      context.missing(_extensionMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    if (data.containsKey('play_position_ms')) {
      context.handle(
        _playPositionMsMeta,
        playPositionMs.isAcceptableOrUnknown(
          data['play_position_ms']!,
          _playPositionMsMeta,
        ),
      );
    }
    if (data.containsKey('play_count')) {
      context.handle(
        _playCountMeta,
        playCount.isAcceptableOrUnknown(data['play_count']!, _playCountMeta),
      );
    }
    if (data.containsKey('is_favourite')) {
      context.handle(
        _isFavouriteMeta,
        isFavourite.isAcceptableOrUnknown(
          data['is_favourite']!,
          _isFavouriteMeta,
        ),
      );
    }
    if (data.containsKey('scanned_at')) {
      context.handle(
        _scannedAtMeta,
        scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_scannedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      absolutePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}absolute_path'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      extension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extension'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder_id'],
      ),
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_played_at'],
      ),
      playPositionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}play_position_ms'],
      )!,
      playCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}play_count'],
      )!,
      isFavourite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favourite'],
      )!,
      scannedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scanned_at'],
      )!,
    );
  }

  @override
  $MediaFilesTable createAlias(String alias) {
    return $MediaFilesTable(attachedDatabase, alias);
  }
}

class MediaFile extends DataClass implements Insertable<MediaFile> {
  final int id;
  final String absolutePath;
  final String name;
  final String extension;
  final int sizeBytes;
  final int? durationMs;
  final int? width;
  final int? height;
  final String? thumbnailPath;
  final int? folderId;
  final int? lastPlayedAt;
  final int playPositionMs;
  final int playCount;
  final bool isFavourite;
  final int scannedAt;
  const MediaFile({
    required this.id,
    required this.absolutePath,
    required this.name,
    required this.extension,
    required this.sizeBytes,
    this.durationMs,
    this.width,
    this.height,
    this.thumbnailPath,
    this.folderId,
    this.lastPlayedAt,
    required this.playPositionMs,
    required this.playCount,
    required this.isFavourite,
    required this.scannedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['absolute_path'] = Variable<String>(absolutePath);
    map['name'] = Variable<String>(name);
    map['extension'] = Variable<String>(extension);
    map['size_bytes'] = Variable<int>(sizeBytes);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<int>(folderId);
    }
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<int>(lastPlayedAt);
    }
    map['play_position_ms'] = Variable<int>(playPositionMs);
    map['play_count'] = Variable<int>(playCount);
    map['is_favourite'] = Variable<bool>(isFavourite);
    map['scanned_at'] = Variable<int>(scannedAt);
    return map;
  }

  MediaFilesCompanion toCompanion(bool nullToAbsent) {
    return MediaFilesCompanion(
      id: Value(id),
      absolutePath: Value(absolutePath),
      name: Value(name),
      extension: Value(extension),
      sizeBytes: Value(sizeBytes),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
      playPositionMs: Value(playPositionMs),
      playCount: Value(playCount),
      isFavourite: Value(isFavourite),
      scannedAt: Value(scannedAt),
    );
  }

  factory MediaFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFile(
      id: serializer.fromJson<int>(json['id']),
      absolutePath: serializer.fromJson<String>(json['absolutePath']),
      name: serializer.fromJson<String>(json['name']),
      extension: serializer.fromJson<String>(json['extension']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      folderId: serializer.fromJson<int?>(json['folderId']),
      lastPlayedAt: serializer.fromJson<int?>(json['lastPlayedAt']),
      playPositionMs: serializer.fromJson<int>(json['playPositionMs']),
      playCount: serializer.fromJson<int>(json['playCount']),
      isFavourite: serializer.fromJson<bool>(json['isFavourite']),
      scannedAt: serializer.fromJson<int>(json['scannedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'absolutePath': serializer.toJson<String>(absolutePath),
      'name': serializer.toJson<String>(name),
      'extension': serializer.toJson<String>(extension),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'durationMs': serializer.toJson<int?>(durationMs),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'folderId': serializer.toJson<int?>(folderId),
      'lastPlayedAt': serializer.toJson<int?>(lastPlayedAt),
      'playPositionMs': serializer.toJson<int>(playPositionMs),
      'playCount': serializer.toJson<int>(playCount),
      'isFavourite': serializer.toJson<bool>(isFavourite),
      'scannedAt': serializer.toJson<int>(scannedAt),
    };
  }

  MediaFile copyWith({
    int? id,
    String? absolutePath,
    String? name,
    String? extension,
    int? sizeBytes,
    Value<int?> durationMs = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    Value<int?> folderId = const Value.absent(),
    Value<int?> lastPlayedAt = const Value.absent(),
    int? playPositionMs,
    int? playCount,
    bool? isFavourite,
    int? scannedAt,
  }) => MediaFile(
    id: id ?? this.id,
    absolutePath: absolutePath ?? this.absolutePath,
    name: name ?? this.name,
    extension: extension ?? this.extension,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    folderId: folderId.present ? folderId.value : this.folderId,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
    playPositionMs: playPositionMs ?? this.playPositionMs,
    playCount: playCount ?? this.playCount,
    isFavourite: isFavourite ?? this.isFavourite,
    scannedAt: scannedAt ?? this.scannedAt,
  );
  MediaFile copyWithCompanion(MediaFilesCompanion data) {
    return MediaFile(
      id: data.id.present ? data.id.value : this.id,
      absolutePath: data.absolutePath.present
          ? data.absolutePath.value
          : this.absolutePath,
      name: data.name.present ? data.name.value : this.name,
      extension: data.extension.present ? data.extension.value : this.extension,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
      playPositionMs: data.playPositionMs.present
          ? data.playPositionMs.value
          : this.playPositionMs,
      playCount: data.playCount.present ? data.playCount.value : this.playCount,
      isFavourite: data.isFavourite.present
          ? data.isFavourite.value
          : this.isFavourite,
      scannedAt: data.scannedAt.present ? data.scannedAt.value : this.scannedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaFile(')
          ..write('id: $id, ')
          ..write('absolutePath: $absolutePath, ')
          ..write('name: $name, ')
          ..write('extension: $extension, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('durationMs: $durationMs, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('folderId: $folderId, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('playPositionMs: $playPositionMs, ')
          ..write('playCount: $playCount, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    absolutePath,
    name,
    extension,
    sizeBytes,
    durationMs,
    width,
    height,
    thumbnailPath,
    folderId,
    lastPlayedAt,
    playPositionMs,
    playCount,
    isFavourite,
    scannedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaFile &&
          other.id == this.id &&
          other.absolutePath == this.absolutePath &&
          other.name == this.name &&
          other.extension == this.extension &&
          other.sizeBytes == this.sizeBytes &&
          other.durationMs == this.durationMs &&
          other.width == this.width &&
          other.height == this.height &&
          other.thumbnailPath == this.thumbnailPath &&
          other.folderId == this.folderId &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.playPositionMs == this.playPositionMs &&
          other.playCount == this.playCount &&
          other.isFavourite == this.isFavourite &&
          other.scannedAt == this.scannedAt);
}

class MediaFilesCompanion extends UpdateCompanion<MediaFile> {
  final Value<int> id;
  final Value<String> absolutePath;
  final Value<String> name;
  final Value<String> extension;
  final Value<int> sizeBytes;
  final Value<int?> durationMs;
  final Value<int?> width;
  final Value<int?> height;
  final Value<String?> thumbnailPath;
  final Value<int?> folderId;
  final Value<int?> lastPlayedAt;
  final Value<int> playPositionMs;
  final Value<int> playCount;
  final Value<bool> isFavourite;
  final Value<int> scannedAt;
  const MediaFilesCompanion({
    this.id = const Value.absent(),
    this.absolutePath = const Value.absent(),
    this.name = const Value.absent(),
    this.extension = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.folderId = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.playPositionMs = const Value.absent(),
    this.playCount = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.scannedAt = const Value.absent(),
  });
  MediaFilesCompanion.insert({
    this.id = const Value.absent(),
    required String absolutePath,
    required String name,
    required String extension,
    required int sizeBytes,
    this.durationMs = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.folderId = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.playPositionMs = const Value.absent(),
    this.playCount = const Value.absent(),
    this.isFavourite = const Value.absent(),
    required int scannedAt,
  }) : absolutePath = Value(absolutePath),
       name = Value(name),
       extension = Value(extension),
       sizeBytes = Value(sizeBytes),
       scannedAt = Value(scannedAt);
  static Insertable<MediaFile> custom({
    Expression<int>? id,
    Expression<String>? absolutePath,
    Expression<String>? name,
    Expression<String>? extension,
    Expression<int>? sizeBytes,
    Expression<int>? durationMs,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? thumbnailPath,
    Expression<int>? folderId,
    Expression<int>? lastPlayedAt,
    Expression<int>? playPositionMs,
    Expression<int>? playCount,
    Expression<bool>? isFavourite,
    Expression<int>? scannedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (absolutePath != null) 'absolute_path': absolutePath,
      if (name != null) 'name': name,
      if (extension != null) 'extension': extension,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (durationMs != null) 'duration_ms': durationMs,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (folderId != null) 'folder_id': folderId,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (playPositionMs != null) 'play_position_ms': playPositionMs,
      if (playCount != null) 'play_count': playCount,
      if (isFavourite != null) 'is_favourite': isFavourite,
      if (scannedAt != null) 'scanned_at': scannedAt,
    });
  }

  MediaFilesCompanion copyWith({
    Value<int>? id,
    Value<String>? absolutePath,
    Value<String>? name,
    Value<String>? extension,
    Value<int>? sizeBytes,
    Value<int?>? durationMs,
    Value<int?>? width,
    Value<int?>? height,
    Value<String?>? thumbnailPath,
    Value<int?>? folderId,
    Value<int?>? lastPlayedAt,
    Value<int>? playPositionMs,
    Value<int>? playCount,
    Value<bool>? isFavourite,
    Value<int>? scannedAt,
  }) {
    return MediaFilesCompanion(
      id: id ?? this.id,
      absolutePath: absolutePath ?? this.absolutePath,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      durationMs: durationMs ?? this.durationMs,
      width: width ?? this.width,
      height: height ?? this.height,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      folderId: folderId ?? this.folderId,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      playPositionMs: playPositionMs ?? this.playPositionMs,
      playCount: playCount ?? this.playCount,
      isFavourite: isFavourite ?? this.isFavourite,
      scannedAt: scannedAt ?? this.scannedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (absolutePath.present) {
      map['absolute_path'] = Variable<String>(absolutePath.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (extension.present) {
      map['extension'] = Variable<String>(extension.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<int>(lastPlayedAt.value);
    }
    if (playPositionMs.present) {
      map['play_position_ms'] = Variable<int>(playPositionMs.value);
    }
    if (playCount.present) {
      map['play_count'] = Variable<int>(playCount.value);
    }
    if (isFavourite.present) {
      map['is_favourite'] = Variable<bool>(isFavourite.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<int>(scannedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaFilesCompanion(')
          ..write('id: $id, ')
          ..write('absolutePath: $absolutePath, ')
          ..write('name: $name, ')
          ..write('extension: $extension, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('durationMs: $durationMs, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('folderId: $folderId, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('playPositionMs: $playPositionMs, ')
          ..write('playCount: $playCount, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Playlist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final int id;
  final String name;
  final int createdAt;
  const Playlist({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Playlist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Playlist copyWith({int? id, String? name, int? createdAt}) => Playlist(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> createdAt;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Playlist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlaylistsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? createdAt,
  }) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlaylistEntriesTable extends PlaylistEntries
    with TableInfo<$PlaylistEntriesTable, PlaylistEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES playlists (id)',
    ),
  );
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES media_files (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, playlistId, mediaId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playlist_id'],
      )!,
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $PlaylistEntriesTable createAlias(String alias) {
    return $PlaylistEntriesTable(attachedDatabase, alias);
  }
}

class PlaylistEntry extends DataClass implements Insertable<PlaylistEntry> {
  final int id;
  final int playlistId;
  final int mediaId;
  final int sortOrder;
  const PlaylistEntry({
    required this.id,
    required this.playlistId,
    required this.mediaId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<int>(playlistId);
    map['media_id'] = Variable<int>(mediaId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  PlaylistEntriesCompanion toCompanion(bool nullToAbsent) {
    return PlaylistEntriesCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      mediaId: Value(mediaId),
      sortOrder: Value(sortOrder),
    );
  }

  factory PlaylistEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistEntry(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
      mediaId: serializer.fromJson<int>(json['mediaId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'mediaId': serializer.toJson<int>(mediaId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  PlaylistEntry copyWith({
    int? id,
    int? playlistId,
    int? mediaId,
    int? sortOrder,
  }) => PlaylistEntry(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    mediaId: mediaId ?? this.mediaId,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  PlaylistEntry copyWithCompanion(PlaylistEntriesCompanion data) {
    return PlaylistEntry(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistEntry(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('mediaId: $mediaId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistId, mediaId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistEntry &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.mediaId == this.mediaId &&
          other.sortOrder == this.sortOrder);
}

class PlaylistEntriesCompanion extends UpdateCompanion<PlaylistEntry> {
  final Value<int> id;
  final Value<int> playlistId;
  final Value<int> mediaId;
  final Value<int> sortOrder;
  const PlaylistEntriesCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  PlaylistEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int playlistId,
    required int mediaId,
    required int sortOrder,
  }) : playlistId = Value(playlistId),
       mediaId = Value(mediaId),
       sortOrder = Value(sortOrder);
  static Insertable<PlaylistEntry> custom({
    Expression<int>? id,
    Expression<int>? playlistId,
    Expression<int>? mediaId,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (mediaId != null) 'media_id': mediaId,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  PlaylistEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? playlistId,
    Value<int>? mediaId,
    Value<int>? sortOrder,
  }) {
    return PlaylistEntriesCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      mediaId: mediaId ?? this.mediaId,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistEntriesCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('mediaId: $mediaId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $TransferJobsTable extends TransferJobs
    with TableInfo<$TransferJobsTable, TransferJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransferJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _peerNameMeta = const VerificationMeta(
    'peerName',
  );
  @override
  late final GeneratedColumn<String> peerName = GeneratedColumn<String>(
    'peer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peerIpMeta = const VerificationMeta('peerIp');
  @override
  late final GeneratedColumn<String> peerIp = GeneratedColumn<String>(
    'peer_ip',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesTransferredMeta = const VerificationMeta(
    'bytesTransferred',
  );
  @override
  late final GeneratedColumn<int> bytesTransferred = GeneratedColumn<int>(
    'bytes_transferred',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('queued'),
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<int> finishedAt = GeneratedColumn<int>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savePathMeta = const VerificationMeta(
    'savePath',
  );
  @override
  late final GeneratedColumn<String> savePath = GeneratedColumn<String>(
    'save_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalChunksMeta = const VerificationMeta(
    'totalChunks',
  );
  @override
  late final GeneratedColumn<int> totalChunks = GeneratedColumn<int>(
    'total_chunks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _chunksTransferredMeta = const VerificationMeta(
    'chunksTransferred',
  );
  @override
  late final GeneratedColumn<int> chunksTransferred = GeneratedColumn<int>(
    'chunks_transferred',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _encryptedMeta = const VerificationMeta(
    'encrypted',
  );
  @override
  late final GeneratedColumn<bool> encrypted = GeneratedColumn<bool>(
    'encrypted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("encrypted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _socketPortMeta = const VerificationMeta(
    'socketPort',
  );
  @override
  late final GeneratedColumn<int> socketPort = GeneratedColumn<int>(
    'socket_port',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _peerDeviceIdMeta = const VerificationMeta(
    'peerDeviceId',
  );
  @override
  late final GeneratedColumn<String> peerDeviceId = GeneratedColumn<String>(
    'peer_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    peerName,
    peerIp,
    fileName,
    fileSize,
    bytesTransferred,
    direction,
    status,
    checksum,
    startedAt,
    finishedAt,
    savePath,
    errorMessage,
    totalChunks,
    chunksTransferred,
    encrypted,
    filePath,
    socketPort,
    sessionId,
    peerDeviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfer_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransferJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('peer_name')) {
      context.handle(
        _peerNameMeta,
        peerName.isAcceptableOrUnknown(data['peer_name']!, _peerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_peerNameMeta);
    }
    if (data.containsKey('peer_ip')) {
      context.handle(
        _peerIpMeta,
        peerIp.isAcceptableOrUnknown(data['peer_ip']!, _peerIpMeta),
      );
    } else if (isInserting) {
      context.missing(_peerIpMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('bytes_transferred')) {
      context.handle(
        _bytesTransferredMeta,
        bytesTransferred.isAcceptableOrUnknown(
          data['bytes_transferred']!,
          _bytesTransferredMeta,
        ),
      );
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('save_path')) {
      context.handle(
        _savePathMeta,
        savePath.isAcceptableOrUnknown(data['save_path']!, _savePathMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('total_chunks')) {
      context.handle(
        _totalChunksMeta,
        totalChunks.isAcceptableOrUnknown(
          data['total_chunks']!,
          _totalChunksMeta,
        ),
      );
    }
    if (data.containsKey('chunks_transferred')) {
      context.handle(
        _chunksTransferredMeta,
        chunksTransferred.isAcceptableOrUnknown(
          data['chunks_transferred']!,
          _chunksTransferredMeta,
        ),
      );
    }
    if (data.containsKey('encrypted')) {
      context.handle(
        _encryptedMeta,
        encrypted.isAcceptableOrUnknown(data['encrypted']!, _encryptedMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('socket_port')) {
      context.handle(
        _socketPortMeta,
        socketPort.isAcceptableOrUnknown(data['socket_port']!, _socketPortMeta),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('peer_device_id')) {
      context.handle(
        _peerDeviceIdMeta,
        peerDeviceId.isAcceptableOrUnknown(
          data['peer_device_id']!,
          _peerDeviceIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransferJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      peerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}peer_name'],
      )!,
      peerIp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}peer_ip'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      bytesTransferred: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes_transferred'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      ),
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}finished_at'],
      ),
      savePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}save_path'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      totalChunks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_chunks'],
      )!,
      chunksTransferred: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chunks_transferred'],
      )!,
      encrypted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}encrypted'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      socketPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}socket_port'],
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      peerDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}peer_device_id'],
      )!,
    );
  }

  @override
  $TransferJobsTable createAlias(String alias) {
    return $TransferJobsTable(attachedDatabase, alias);
  }
}

class TransferJob extends DataClass implements Insertable<TransferJob> {
  final int id;
  final String peerName;
  final String peerIp;
  final String fileName;
  final int fileSize;
  final int bytesTransferred;

  /// 'send' or 'receive'
  final String direction;

  /// 'queued' | 'active' | 'paused' | 'completed' | 'failed' | 'cancelled'
  final String status;
  final String? checksum;
  final int? startedAt;
  final int? finishedAt;
  final String? savePath;
  final String? errorMessage;

  /// Total number of chunks for this file.
  final int totalChunks;

  /// Number of chunks already transferred.
  final int chunksTransferred;

  /// Whether this transfer was encrypted.
  final bool encrypted;

  /// Source file path (for resume on sender side).
  final String? filePath;

  /// Peer's socket port (for reconnection/resume).
  final int? socketPort;

  /// Groups multi-file transfers under one session.
  final String? sessionId;

  /// Peer device ID for identification.
  final String peerDeviceId;
  const TransferJob({
    required this.id,
    required this.peerName,
    required this.peerIp,
    required this.fileName,
    required this.fileSize,
    required this.bytesTransferred,
    required this.direction,
    required this.status,
    this.checksum,
    this.startedAt,
    this.finishedAt,
    this.savePath,
    this.errorMessage,
    required this.totalChunks,
    required this.chunksTransferred,
    required this.encrypted,
    this.filePath,
    this.socketPort,
    this.sessionId,
    required this.peerDeviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['peer_name'] = Variable<String>(peerName);
    map['peer_ip'] = Variable<String>(peerIp);
    map['file_name'] = Variable<String>(fileName);
    map['file_size'] = Variable<int>(fileSize);
    map['bytes_transferred'] = Variable<int>(bytesTransferred);
    map['direction'] = Variable<String>(direction);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || checksum != null) {
      map['checksum'] = Variable<String>(checksum);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<int>(startedAt);
    }
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<int>(finishedAt);
    }
    if (!nullToAbsent || savePath != null) {
      map['save_path'] = Variable<String>(savePath);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['total_chunks'] = Variable<int>(totalChunks);
    map['chunks_transferred'] = Variable<int>(chunksTransferred);
    map['encrypted'] = Variable<bool>(encrypted);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || socketPort != null) {
      map['socket_port'] = Variable<int>(socketPort);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['peer_device_id'] = Variable<String>(peerDeviceId);
    return map;
  }

  TransferJobsCompanion toCompanion(bool nullToAbsent) {
    return TransferJobsCompanion(
      id: Value(id),
      peerName: Value(peerName),
      peerIp: Value(peerIp),
      fileName: Value(fileName),
      fileSize: Value(fileSize),
      bytesTransferred: Value(bytesTransferred),
      direction: Value(direction),
      status: Value(status),
      checksum: checksum == null && nullToAbsent
          ? const Value.absent()
          : Value(checksum),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      savePath: savePath == null && nullToAbsent
          ? const Value.absent()
          : Value(savePath),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      totalChunks: Value(totalChunks),
      chunksTransferred: Value(chunksTransferred),
      encrypted: Value(encrypted),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      socketPort: socketPort == null && nullToAbsent
          ? const Value.absent()
          : Value(socketPort),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      peerDeviceId: Value(peerDeviceId),
    );
  }

  factory TransferJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransferJob(
      id: serializer.fromJson<int>(json['id']),
      peerName: serializer.fromJson<String>(json['peerName']),
      peerIp: serializer.fromJson<String>(json['peerIp']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      bytesTransferred: serializer.fromJson<int>(json['bytesTransferred']),
      direction: serializer.fromJson<String>(json['direction']),
      status: serializer.fromJson<String>(json['status']),
      checksum: serializer.fromJson<String?>(json['checksum']),
      startedAt: serializer.fromJson<int?>(json['startedAt']),
      finishedAt: serializer.fromJson<int?>(json['finishedAt']),
      savePath: serializer.fromJson<String?>(json['savePath']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      totalChunks: serializer.fromJson<int>(json['totalChunks']),
      chunksTransferred: serializer.fromJson<int>(json['chunksTransferred']),
      encrypted: serializer.fromJson<bool>(json['encrypted']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      socketPort: serializer.fromJson<int?>(json['socketPort']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      peerDeviceId: serializer.fromJson<String>(json['peerDeviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'peerName': serializer.toJson<String>(peerName),
      'peerIp': serializer.toJson<String>(peerIp),
      'fileName': serializer.toJson<String>(fileName),
      'fileSize': serializer.toJson<int>(fileSize),
      'bytesTransferred': serializer.toJson<int>(bytesTransferred),
      'direction': serializer.toJson<String>(direction),
      'status': serializer.toJson<String>(status),
      'checksum': serializer.toJson<String?>(checksum),
      'startedAt': serializer.toJson<int?>(startedAt),
      'finishedAt': serializer.toJson<int?>(finishedAt),
      'savePath': serializer.toJson<String?>(savePath),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'totalChunks': serializer.toJson<int>(totalChunks),
      'chunksTransferred': serializer.toJson<int>(chunksTransferred),
      'encrypted': serializer.toJson<bool>(encrypted),
      'filePath': serializer.toJson<String?>(filePath),
      'socketPort': serializer.toJson<int?>(socketPort),
      'sessionId': serializer.toJson<String?>(sessionId),
      'peerDeviceId': serializer.toJson<String>(peerDeviceId),
    };
  }

  TransferJob copyWith({
    int? id,
    String? peerName,
    String? peerIp,
    String? fileName,
    int? fileSize,
    int? bytesTransferred,
    String? direction,
    String? status,
    Value<String?> checksum = const Value.absent(),
    Value<int?> startedAt = const Value.absent(),
    Value<int?> finishedAt = const Value.absent(),
    Value<String?> savePath = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    int? totalChunks,
    int? chunksTransferred,
    bool? encrypted,
    Value<String?> filePath = const Value.absent(),
    Value<int?> socketPort = const Value.absent(),
    Value<String?> sessionId = const Value.absent(),
    String? peerDeviceId,
  }) => TransferJob(
    id: id ?? this.id,
    peerName: peerName ?? this.peerName,
    peerIp: peerIp ?? this.peerIp,
    fileName: fileName ?? this.fileName,
    fileSize: fileSize ?? this.fileSize,
    bytesTransferred: bytesTransferred ?? this.bytesTransferred,
    direction: direction ?? this.direction,
    status: status ?? this.status,
    checksum: checksum.present ? checksum.value : this.checksum,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    savePath: savePath.present ? savePath.value : this.savePath,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    totalChunks: totalChunks ?? this.totalChunks,
    chunksTransferred: chunksTransferred ?? this.chunksTransferred,
    encrypted: encrypted ?? this.encrypted,
    filePath: filePath.present ? filePath.value : this.filePath,
    socketPort: socketPort.present ? socketPort.value : this.socketPort,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    peerDeviceId: peerDeviceId ?? this.peerDeviceId,
  );
  TransferJob copyWithCompanion(TransferJobsCompanion data) {
    return TransferJob(
      id: data.id.present ? data.id.value : this.id,
      peerName: data.peerName.present ? data.peerName.value : this.peerName,
      peerIp: data.peerIp.present ? data.peerIp.value : this.peerIp,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      bytesTransferred: data.bytesTransferred.present
          ? data.bytesTransferred.value
          : this.bytesTransferred,
      direction: data.direction.present ? data.direction.value : this.direction,
      status: data.status.present ? data.status.value : this.status,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      savePath: data.savePath.present ? data.savePath.value : this.savePath,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      totalChunks: data.totalChunks.present
          ? data.totalChunks.value
          : this.totalChunks,
      chunksTransferred: data.chunksTransferred.present
          ? data.chunksTransferred.value
          : this.chunksTransferred,
      encrypted: data.encrypted.present ? data.encrypted.value : this.encrypted,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      socketPort: data.socketPort.present
          ? data.socketPort.value
          : this.socketPort,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      peerDeviceId: data.peerDeviceId.present
          ? data.peerDeviceId.value
          : this.peerDeviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransferJob(')
          ..write('id: $id, ')
          ..write('peerName: $peerName, ')
          ..write('peerIp: $peerIp, ')
          ..write('fileName: $fileName, ')
          ..write('fileSize: $fileSize, ')
          ..write('bytesTransferred: $bytesTransferred, ')
          ..write('direction: $direction, ')
          ..write('status: $status, ')
          ..write('checksum: $checksum, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('savePath: $savePath, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('totalChunks: $totalChunks, ')
          ..write('chunksTransferred: $chunksTransferred, ')
          ..write('encrypted: $encrypted, ')
          ..write('filePath: $filePath, ')
          ..write('socketPort: $socketPort, ')
          ..write('sessionId: $sessionId, ')
          ..write('peerDeviceId: $peerDeviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    peerName,
    peerIp,
    fileName,
    fileSize,
    bytesTransferred,
    direction,
    status,
    checksum,
    startedAt,
    finishedAt,
    savePath,
    errorMessage,
    totalChunks,
    chunksTransferred,
    encrypted,
    filePath,
    socketPort,
    sessionId,
    peerDeviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferJob &&
          other.id == this.id &&
          other.peerName == this.peerName &&
          other.peerIp == this.peerIp &&
          other.fileName == this.fileName &&
          other.fileSize == this.fileSize &&
          other.bytesTransferred == this.bytesTransferred &&
          other.direction == this.direction &&
          other.status == this.status &&
          other.checksum == this.checksum &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.savePath == this.savePath &&
          other.errorMessage == this.errorMessage &&
          other.totalChunks == this.totalChunks &&
          other.chunksTransferred == this.chunksTransferred &&
          other.encrypted == this.encrypted &&
          other.filePath == this.filePath &&
          other.socketPort == this.socketPort &&
          other.sessionId == this.sessionId &&
          other.peerDeviceId == this.peerDeviceId);
}

class TransferJobsCompanion extends UpdateCompanion<TransferJob> {
  final Value<int> id;
  final Value<String> peerName;
  final Value<String> peerIp;
  final Value<String> fileName;
  final Value<int> fileSize;
  final Value<int> bytesTransferred;
  final Value<String> direction;
  final Value<String> status;
  final Value<String?> checksum;
  final Value<int?> startedAt;
  final Value<int?> finishedAt;
  final Value<String?> savePath;
  final Value<String?> errorMessage;
  final Value<int> totalChunks;
  final Value<int> chunksTransferred;
  final Value<bool> encrypted;
  final Value<String?> filePath;
  final Value<int?> socketPort;
  final Value<String?> sessionId;
  final Value<String> peerDeviceId;
  const TransferJobsCompanion({
    this.id = const Value.absent(),
    this.peerName = const Value.absent(),
    this.peerIp = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.bytesTransferred = const Value.absent(),
    this.direction = const Value.absent(),
    this.status = const Value.absent(),
    this.checksum = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.savePath = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.totalChunks = const Value.absent(),
    this.chunksTransferred = const Value.absent(),
    this.encrypted = const Value.absent(),
    this.filePath = const Value.absent(),
    this.socketPort = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.peerDeviceId = const Value.absent(),
  });
  TransferJobsCompanion.insert({
    this.id = const Value.absent(),
    required String peerName,
    required String peerIp,
    required String fileName,
    required int fileSize,
    this.bytesTransferred = const Value.absent(),
    required String direction,
    this.status = const Value.absent(),
    this.checksum = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.savePath = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.totalChunks = const Value.absent(),
    this.chunksTransferred = const Value.absent(),
    this.encrypted = const Value.absent(),
    this.filePath = const Value.absent(),
    this.socketPort = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.peerDeviceId = const Value.absent(),
  }) : peerName = Value(peerName),
       peerIp = Value(peerIp),
       fileName = Value(fileName),
       fileSize = Value(fileSize),
       direction = Value(direction);
  static Insertable<TransferJob> custom({
    Expression<int>? id,
    Expression<String>? peerName,
    Expression<String>? peerIp,
    Expression<String>? fileName,
    Expression<int>? fileSize,
    Expression<int>? bytesTransferred,
    Expression<String>? direction,
    Expression<String>? status,
    Expression<String>? checksum,
    Expression<int>? startedAt,
    Expression<int>? finishedAt,
    Expression<String>? savePath,
    Expression<String>? errorMessage,
    Expression<int>? totalChunks,
    Expression<int>? chunksTransferred,
    Expression<bool>? encrypted,
    Expression<String>? filePath,
    Expression<int>? socketPort,
    Expression<String>? sessionId,
    Expression<String>? peerDeviceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (peerName != null) 'peer_name': peerName,
      if (peerIp != null) 'peer_ip': peerIp,
      if (fileName != null) 'file_name': fileName,
      if (fileSize != null) 'file_size': fileSize,
      if (bytesTransferred != null) 'bytes_transferred': bytesTransferred,
      if (direction != null) 'direction': direction,
      if (status != null) 'status': status,
      if (checksum != null) 'checksum': checksum,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (savePath != null) 'save_path': savePath,
      if (errorMessage != null) 'error_message': errorMessage,
      if (totalChunks != null) 'total_chunks': totalChunks,
      if (chunksTransferred != null) 'chunks_transferred': chunksTransferred,
      if (encrypted != null) 'encrypted': encrypted,
      if (filePath != null) 'file_path': filePath,
      if (socketPort != null) 'socket_port': socketPort,
      if (sessionId != null) 'session_id': sessionId,
      if (peerDeviceId != null) 'peer_device_id': peerDeviceId,
    });
  }

  TransferJobsCompanion copyWith({
    Value<int>? id,
    Value<String>? peerName,
    Value<String>? peerIp,
    Value<String>? fileName,
    Value<int>? fileSize,
    Value<int>? bytesTransferred,
    Value<String>? direction,
    Value<String>? status,
    Value<String?>? checksum,
    Value<int?>? startedAt,
    Value<int?>? finishedAt,
    Value<String?>? savePath,
    Value<String?>? errorMessage,
    Value<int>? totalChunks,
    Value<int>? chunksTransferred,
    Value<bool>? encrypted,
    Value<String?>? filePath,
    Value<int?>? socketPort,
    Value<String?>? sessionId,
    Value<String>? peerDeviceId,
  }) {
    return TransferJobsCompanion(
      id: id ?? this.id,
      peerName: peerName ?? this.peerName,
      peerIp: peerIp ?? this.peerIp,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      bytesTransferred: bytesTransferred ?? this.bytesTransferred,
      direction: direction ?? this.direction,
      status: status ?? this.status,
      checksum: checksum ?? this.checksum,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      savePath: savePath ?? this.savePath,
      errorMessage: errorMessage ?? this.errorMessage,
      totalChunks: totalChunks ?? this.totalChunks,
      chunksTransferred: chunksTransferred ?? this.chunksTransferred,
      encrypted: encrypted ?? this.encrypted,
      filePath: filePath ?? this.filePath,
      socketPort: socketPort ?? this.socketPort,
      sessionId: sessionId ?? this.sessionId,
      peerDeviceId: peerDeviceId ?? this.peerDeviceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (peerName.present) {
      map['peer_name'] = Variable<String>(peerName.value);
    }
    if (peerIp.present) {
      map['peer_ip'] = Variable<String>(peerIp.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (bytesTransferred.present) {
      map['bytes_transferred'] = Variable<int>(bytesTransferred.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<int>(finishedAt.value);
    }
    if (savePath.present) {
      map['save_path'] = Variable<String>(savePath.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (totalChunks.present) {
      map['total_chunks'] = Variable<int>(totalChunks.value);
    }
    if (chunksTransferred.present) {
      map['chunks_transferred'] = Variable<int>(chunksTransferred.value);
    }
    if (encrypted.present) {
      map['encrypted'] = Variable<bool>(encrypted.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (socketPort.present) {
      map['socket_port'] = Variable<int>(socketPort.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (peerDeviceId.present) {
      map['peer_device_id'] = Variable<String>(peerDeviceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferJobsCompanion(')
          ..write('id: $id, ')
          ..write('peerName: $peerName, ')
          ..write('peerIp: $peerIp, ')
          ..write('fileName: $fileName, ')
          ..write('fileSize: $fileSize, ')
          ..write('bytesTransferred: $bytesTransferred, ')
          ..write('direction: $direction, ')
          ..write('status: $status, ')
          ..write('checksum: $checksum, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('savePath: $savePath, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('totalChunks: $totalChunks, ')
          ..write('chunksTransferred: $chunksTransferred, ')
          ..write('encrypted: $encrypted, ')
          ..write('filePath: $filePath, ')
          ..write('socketPort: $socketPort, ')
          ..write('sessionId: $sessionId, ')
          ..write('peerDeviceId: $peerDeviceId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MediaFoldersTable mediaFolders = $MediaFoldersTable(this);
  late final $MediaFilesTable mediaFiles = $MediaFilesTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistEntriesTable playlistEntries = $PlaylistEntriesTable(
    this,
  );
  late final $TransferJobsTable transferJobs = $TransferJobsTable(this);
  late final MediaDao mediaDao = MediaDao(this as AppDatabase);
  late final FolderDao folderDao = FolderDao(this as AppDatabase);
  late final PlaylistDao playlistDao = PlaylistDao(this as AppDatabase);
  late final TransferDao transferDao = TransferDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    mediaFolders,
    mediaFiles,
    playlists,
    playlistEntries,
    transferJobs,
  ];
}

typedef $$MediaFoldersTableCreateCompanionBuilder =
    MediaFoldersCompanion Function({
      Value<int> id,
      required String absolutePath,
      required String name,
      Value<int?> parentId,
      Value<String?> thumbnailPath,
      Value<int> videoCount,
      Value<int> audioCount,
      Value<bool> isWatched,
    });
typedef $$MediaFoldersTableUpdateCompanionBuilder =
    MediaFoldersCompanion Function({
      Value<int> id,
      Value<String> absolutePath,
      Value<String> name,
      Value<int?> parentId,
      Value<String?> thumbnailPath,
      Value<int> videoCount,
      Value<int> audioCount,
      Value<bool> isWatched,
    });

final class $$MediaFoldersTableReferences
    extends BaseReferences<_$AppDatabase, $MediaFoldersTable, MediaFolder> {
  $$MediaFoldersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MediaFoldersTable _parentIdTable(_$AppDatabase db) =>
      db.mediaFolders.createAlias(
        $_aliasNameGenerator(db.mediaFolders.parentId, db.mediaFolders.id),
      );

  $$MediaFoldersTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$MediaFoldersTableTableManager(
      $_db,
      $_db.mediaFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MediaFilesTable, List<MediaFile>>
  _mediaFilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaFiles,
    aliasName: $_aliasNameGenerator(db.mediaFolders.id, db.mediaFiles.folderId),
  );

  $$MediaFilesTableProcessedTableManager get mediaFilesRefs {
    final manager = $$MediaFilesTableTableManager(
      $_db,
      $_db.mediaFiles,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediaFoldersTableFilterComposer
    extends Composer<_$AppDatabase, $MediaFoldersTable> {
  $$MediaFoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get absolutePath => $composableBuilder(
    column: $table.absolutePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get videoCount => $composableBuilder(
    column: $table.videoCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get audioCount => $composableBuilder(
    column: $table.audioCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWatched => $composableBuilder(
    column: $table.isWatched,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaFoldersTableFilterComposer get parentId {
    final $$MediaFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.mediaFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFoldersTableFilterComposer(
            $db: $db,
            $table: $db.mediaFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mediaFilesRefs(
    Expression<bool> Function($$MediaFilesTableFilterComposer f) f,
  ) {
    final $$MediaFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableFilterComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaFoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaFoldersTable> {
  $$MediaFoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get absolutePath => $composableBuilder(
    column: $table.absolutePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get videoCount => $composableBuilder(
    column: $table.videoCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get audioCount => $composableBuilder(
    column: $table.audioCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWatched => $composableBuilder(
    column: $table.isWatched,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaFoldersTableOrderingComposer get parentId {
    final $$MediaFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.mediaFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFoldersTableOrderingComposer(
            $db: $db,
            $table: $db.mediaFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaFoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaFoldersTable> {
  $$MediaFoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get absolutePath => $composableBuilder(
    column: $table.absolutePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get videoCount => $composableBuilder(
    column: $table.videoCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get audioCount => $composableBuilder(
    column: $table.audioCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isWatched =>
      $composableBuilder(column: $table.isWatched, builder: (column) => column);

  $$MediaFoldersTableAnnotationComposer get parentId {
    final $$MediaFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.mediaFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mediaFilesRefs<T extends Object>(
    Expression<T> Function($$MediaFilesTableAnnotationComposer a) f,
  ) {
    final $$MediaFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaFoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaFoldersTable,
          MediaFolder,
          $$MediaFoldersTableFilterComposer,
          $$MediaFoldersTableOrderingComposer,
          $$MediaFoldersTableAnnotationComposer,
          $$MediaFoldersTableCreateCompanionBuilder,
          $$MediaFoldersTableUpdateCompanionBuilder,
          (MediaFolder, $$MediaFoldersTableReferences),
          MediaFolder,
          PrefetchHooks Function({bool parentId, bool mediaFilesRefs})
        > {
  $$MediaFoldersTableTableManager(_$AppDatabase db, $MediaFoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaFoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaFoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaFoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> absolutePath = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<int> videoCount = const Value.absent(),
                Value<int> audioCount = const Value.absent(),
                Value<bool> isWatched = const Value.absent(),
              }) => MediaFoldersCompanion(
                id: id,
                absolutePath: absolutePath,
                name: name,
                parentId: parentId,
                thumbnailPath: thumbnailPath,
                videoCount: videoCount,
                audioCount: audioCount,
                isWatched: isWatched,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String absolutePath,
                required String name,
                Value<int?> parentId = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<int> videoCount = const Value.absent(),
                Value<int> audioCount = const Value.absent(),
                Value<bool> isWatched = const Value.absent(),
              }) => MediaFoldersCompanion.insert(
                id: id,
                absolutePath: absolutePath,
                name: name,
                parentId: parentId,
                thumbnailPath: thumbnailPath,
                videoCount: videoCount,
                audioCount: audioCount,
                isWatched: isWatched,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaFoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({parentId = false, mediaFilesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mediaFilesRefs) db.mediaFiles],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (parentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.parentId,
                                referencedTable: $$MediaFoldersTableReferences
                                    ._parentIdTable(db),
                                referencedColumn: $$MediaFoldersTableReferences
                                    ._parentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mediaFilesRefs)
                    await $_getPrefetchedData<
                      MediaFolder,
                      $MediaFoldersTable,
                      MediaFile
                    >(
                      currentTable: table,
                      referencedTable: $$MediaFoldersTableReferences
                          ._mediaFilesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MediaFoldersTableReferences(
                            db,
                            table,
                            p0,
                          ).mediaFilesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.folderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MediaFoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaFoldersTable,
      MediaFolder,
      $$MediaFoldersTableFilterComposer,
      $$MediaFoldersTableOrderingComposer,
      $$MediaFoldersTableAnnotationComposer,
      $$MediaFoldersTableCreateCompanionBuilder,
      $$MediaFoldersTableUpdateCompanionBuilder,
      (MediaFolder, $$MediaFoldersTableReferences),
      MediaFolder,
      PrefetchHooks Function({bool parentId, bool mediaFilesRefs})
    >;
typedef $$MediaFilesTableCreateCompanionBuilder =
    MediaFilesCompanion Function({
      Value<int> id,
      required String absolutePath,
      required String name,
      required String extension,
      required int sizeBytes,
      Value<int?> durationMs,
      Value<int?> width,
      Value<int?> height,
      Value<String?> thumbnailPath,
      Value<int?> folderId,
      Value<int?> lastPlayedAt,
      Value<int> playPositionMs,
      Value<int> playCount,
      Value<bool> isFavourite,
      required int scannedAt,
    });
typedef $$MediaFilesTableUpdateCompanionBuilder =
    MediaFilesCompanion Function({
      Value<int> id,
      Value<String> absolutePath,
      Value<String> name,
      Value<String> extension,
      Value<int> sizeBytes,
      Value<int?> durationMs,
      Value<int?> width,
      Value<int?> height,
      Value<String?> thumbnailPath,
      Value<int?> folderId,
      Value<int?> lastPlayedAt,
      Value<int> playPositionMs,
      Value<int> playCount,
      Value<bool> isFavourite,
      Value<int> scannedAt,
    });

final class $$MediaFilesTableReferences
    extends BaseReferences<_$AppDatabase, $MediaFilesTable, MediaFile> {
  $$MediaFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MediaFoldersTable _folderIdTable(_$AppDatabase db) =>
      db.mediaFolders.createAlias(
        $_aliasNameGenerator(db.mediaFiles.folderId, db.mediaFolders.id),
      );

  $$MediaFoldersTableProcessedTableManager? get folderId {
    final $_column = $_itemColumn<int>('folder_id');
    if ($_column == null) return null;
    final manager = $$MediaFoldersTableTableManager(
      $_db,
      $_db.mediaFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlaylistEntriesTable, List<PlaylistEntry>>
  _playlistEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playlistEntries,
    aliasName: $_aliasNameGenerator(
      db.mediaFiles.id,
      db.playlistEntries.mediaId,
    ),
  );

  $$PlaylistEntriesTableProcessedTableManager get playlistEntriesRefs {
    final manager = $$PlaylistEntriesTableTableManager(
      $_db,
      $_db.playlistEntries,
    ).filter((f) => f.mediaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _playlistEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediaFilesTableFilterComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get absolutePath => $composableBuilder(
    column: $table.absolutePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extension => $composableBuilder(
    column: $table.extension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playPositionMs => $composableBuilder(
    column: $table.playPositionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MediaFoldersTableFilterComposer get folderId {
    final $$MediaFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.mediaFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFoldersTableFilterComposer(
            $db: $db,
            $table: $db.mediaFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> playlistEntriesRefs(
    Expression<bool> Function($$PlaylistEntriesTableFilterComposer f) f,
  ) {
    final $$PlaylistEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistEntries,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistEntriesTableFilterComposer(
            $db: $db,
            $table: $db.playlistEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get absolutePath => $composableBuilder(
    column: $table.absolutePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extension => $composableBuilder(
    column: $table.extension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playPositionMs => $composableBuilder(
    column: $table.playPositionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MediaFoldersTableOrderingComposer get folderId {
    final $$MediaFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.mediaFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFoldersTableOrderingComposer(
            $db: $db,
            $table: $db.mediaFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get absolutePath => $composableBuilder(
    column: $table.absolutePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get extension =>
      $composableBuilder(column: $table.extension, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playPositionMs => $composableBuilder(
    column: $table.playPositionMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playCount =>
      $composableBuilder(column: $table.playCount, builder: (column) => column);

  GeneratedColumn<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);

  $$MediaFoldersTableAnnotationComposer get folderId {
    final $$MediaFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.mediaFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> playlistEntriesRefs<T extends Object>(
    Expression<T> Function($$PlaylistEntriesTableAnnotationComposer a) f,
  ) {
    final $$PlaylistEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistEntries,
      getReferencedColumn: (t) => t.mediaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaFilesTable,
          MediaFile,
          $$MediaFilesTableFilterComposer,
          $$MediaFilesTableOrderingComposer,
          $$MediaFilesTableAnnotationComposer,
          $$MediaFilesTableCreateCompanionBuilder,
          $$MediaFilesTableUpdateCompanionBuilder,
          (MediaFile, $$MediaFilesTableReferences),
          MediaFile,
          PrefetchHooks Function({bool folderId, bool playlistEntriesRefs})
        > {
  $$MediaFilesTableTableManager(_$AppDatabase db, $MediaFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> absolutePath = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> extension = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<int?> folderId = const Value.absent(),
                Value<int?> lastPlayedAt = const Value.absent(),
                Value<int> playPositionMs = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<bool> isFavourite = const Value.absent(),
                Value<int> scannedAt = const Value.absent(),
              }) => MediaFilesCompanion(
                id: id,
                absolutePath: absolutePath,
                name: name,
                extension: extension,
                sizeBytes: sizeBytes,
                durationMs: durationMs,
                width: width,
                height: height,
                thumbnailPath: thumbnailPath,
                folderId: folderId,
                lastPlayedAt: lastPlayedAt,
                playPositionMs: playPositionMs,
                playCount: playCount,
                isFavourite: isFavourite,
                scannedAt: scannedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String absolutePath,
                required String name,
                required String extension,
                required int sizeBytes,
                Value<int?> durationMs = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<int?> folderId = const Value.absent(),
                Value<int?> lastPlayedAt = const Value.absent(),
                Value<int> playPositionMs = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<bool> isFavourite = const Value.absent(),
                required int scannedAt,
              }) => MediaFilesCompanion.insert(
                id: id,
                absolutePath: absolutePath,
                name: name,
                extension: extension,
                sizeBytes: sizeBytes,
                durationMs: durationMs,
                width: width,
                height: height,
                thumbnailPath: thumbnailPath,
                folderId: folderId,
                lastPlayedAt: lastPlayedAt,
                playPositionMs: playPositionMs,
                playCount: playCount,
                isFavourite: isFavourite,
                scannedAt: scannedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaFilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({folderId = false, playlistEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playlistEntriesRefs) db.playlistEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (folderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.folderId,
                                    referencedTable: $$MediaFilesTableReferences
                                        ._folderIdTable(db),
                                    referencedColumn:
                                        $$MediaFilesTableReferences
                                            ._folderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playlistEntriesRefs)
                        await $_getPrefetchedData<
                          MediaFile,
                          $MediaFilesTable,
                          PlaylistEntry
                        >(
                          currentTable: table,
                          referencedTable: $$MediaFilesTableReferences
                              ._playlistEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaFilesTableReferences(
                                db,
                                table,
                                p0,
                              ).playlistEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MediaFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaFilesTable,
      MediaFile,
      $$MediaFilesTableFilterComposer,
      $$MediaFilesTableOrderingComposer,
      $$MediaFilesTableAnnotationComposer,
      $$MediaFilesTableCreateCompanionBuilder,
      $$MediaFilesTableUpdateCompanionBuilder,
      (MediaFile, $$MediaFilesTableReferences),
      MediaFile,
      PrefetchHooks Function({bool folderId, bool playlistEntriesRefs})
    >;
typedef $$PlaylistsTableCreateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<int> id,
      required String name,
      required int createdAt,
    });
typedef $$PlaylistsTableUpdateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> createdAt,
    });

final class $$PlaylistsTableReferences
    extends BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist> {
  $$PlaylistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistEntriesTable, List<PlaylistEntry>>
  _playlistEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playlistEntries,
    aliasName: $_aliasNameGenerator(
      db.playlists.id,
      db.playlistEntries.playlistId,
    ),
  );

  $$PlaylistEntriesTableProcessedTableManager get playlistEntriesRefs {
    final manager = $$PlaylistEntriesTableTableManager(
      $_db,
      $_db.playlistEntries,
    ).filter((f) => f.playlistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _playlistEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playlistEntriesRefs(
    Expression<bool> Function($$PlaylistEntriesTableFilterComposer f) f,
  ) {
    final $$PlaylistEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistEntries,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistEntriesTableFilterComposer(
            $db: $db,
            $table: $db.playlistEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> playlistEntriesRefs<T extends Object>(
    Expression<T> Function($$PlaylistEntriesTableAnnotationComposer a) f,
  ) {
    final $$PlaylistEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playlistEntries,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.playlistEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistsTable,
          Playlist,
          $$PlaylistsTableFilterComposer,
          $$PlaylistsTableOrderingComposer,
          $$PlaylistsTableAnnotationComposer,
          $$PlaylistsTableCreateCompanionBuilder,
          $$PlaylistsTableUpdateCompanionBuilder,
          (Playlist, $$PlaylistsTableReferences),
          Playlist,
          PrefetchHooks Function({bool playlistEntriesRefs})
        > {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) =>
                  PlaylistsCompanion(id: id, name: name, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int createdAt,
              }) => PlaylistsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistEntriesRefs) db.playlistEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistEntriesRefs)
                    await $_getPrefetchedData<
                      Playlist,
                      $PlaylistsTable,
                      PlaylistEntry
                    >(
                      currentTable: table,
                      referencedTable: $$PlaylistsTableReferences
                          ._playlistEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlaylistsTableReferences(
                            db,
                            table,
                            p0,
                          ).playlistEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playlistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistsTable,
      Playlist,
      $$PlaylistsTableFilterComposer,
      $$PlaylistsTableOrderingComposer,
      $$PlaylistsTableAnnotationComposer,
      $$PlaylistsTableCreateCompanionBuilder,
      $$PlaylistsTableUpdateCompanionBuilder,
      (Playlist, $$PlaylistsTableReferences),
      Playlist,
      PrefetchHooks Function({bool playlistEntriesRefs})
    >;
typedef $$PlaylistEntriesTableCreateCompanionBuilder =
    PlaylistEntriesCompanion Function({
      Value<int> id,
      required int playlistId,
      required int mediaId,
      required int sortOrder,
    });
typedef $$PlaylistEntriesTableUpdateCompanionBuilder =
    PlaylistEntriesCompanion Function({
      Value<int> id,
      Value<int> playlistId,
      Value<int> mediaId,
      Value<int> sortOrder,
    });

final class $$PlaylistEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PlaylistEntriesTable, PlaylistEntry> {
  $$PlaylistEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlaylistsTable _playlistIdTable(_$AppDatabase db) =>
      db.playlists.createAlias(
        $_aliasNameGenerator(db.playlistEntries.playlistId, db.playlists.id),
      );

  $$PlaylistsTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<int>('playlist_id')!;

    final manager = $$PlaylistsTableTableManager(
      $_db,
      $_db.playlists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MediaFilesTable _mediaIdTable(_$AppDatabase db) =>
      db.mediaFiles.createAlias(
        $_aliasNameGenerator(db.playlistEntries.mediaId, db.mediaFiles.id),
      );

  $$MediaFilesTableProcessedTableManager get mediaId {
    final $_column = $_itemColumn<int>('media_id')!;

    final manager = $$MediaFilesTableTableManager(
      $_db,
      $_db.mediaFiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaylistEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistEntriesTable> {
  $$PlaylistEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$PlaylistsTableFilterComposer get playlistId {
    final $$PlaylistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableFilterComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaFilesTableFilterComposer get mediaId {
    final $$MediaFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableFilterComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistEntriesTable> {
  $$PlaylistEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlaylistsTableOrderingComposer get playlistId {
    final $$PlaylistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableOrderingComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaFilesTableOrderingComposer get mediaId {
    final $$MediaFilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableOrderingComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistEntriesTable> {
  $$PlaylistEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$PlaylistsTableAnnotationComposer get playlistId {
    final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.playlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaylistsTableAnnotationComposer(
            $db: $db,
            $table: $db.playlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaFilesTableAnnotationComposer get mediaId {
    final $$MediaFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaId,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaylistEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistEntriesTable,
          PlaylistEntry,
          $$PlaylistEntriesTableFilterComposer,
          $$PlaylistEntriesTableOrderingComposer,
          $$PlaylistEntriesTableAnnotationComposer,
          $$PlaylistEntriesTableCreateCompanionBuilder,
          $$PlaylistEntriesTableUpdateCompanionBuilder,
          (PlaylistEntry, $$PlaylistEntriesTableReferences),
          PlaylistEntry,
          PrefetchHooks Function({bool playlistId, bool mediaId})
        > {
  $$PlaylistEntriesTableTableManager(
    _$AppDatabase db,
    $PlaylistEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> playlistId = const Value.absent(),
                Value<int> mediaId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => PlaylistEntriesCompanion(
                id: id,
                playlistId: playlistId,
                mediaId: mediaId,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int playlistId,
                required int mediaId,
                required int sortOrder,
              }) => PlaylistEntriesCompanion.insert(
                id: id,
                playlistId: playlistId,
                mediaId: mediaId,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaylistEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playlistId = false, mediaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (playlistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playlistId,
                                referencedTable:
                                    $$PlaylistEntriesTableReferences
                                        ._playlistIdTable(db),
                                referencedColumn:
                                    $$PlaylistEntriesTableReferences
                                        ._playlistIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (mediaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mediaId,
                                referencedTable:
                                    $$PlaylistEntriesTableReferences
                                        ._mediaIdTable(db),
                                referencedColumn:
                                    $$PlaylistEntriesTableReferences
                                        ._mediaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaylistEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistEntriesTable,
      PlaylistEntry,
      $$PlaylistEntriesTableFilterComposer,
      $$PlaylistEntriesTableOrderingComposer,
      $$PlaylistEntriesTableAnnotationComposer,
      $$PlaylistEntriesTableCreateCompanionBuilder,
      $$PlaylistEntriesTableUpdateCompanionBuilder,
      (PlaylistEntry, $$PlaylistEntriesTableReferences),
      PlaylistEntry,
      PrefetchHooks Function({bool playlistId, bool mediaId})
    >;
typedef $$TransferJobsTableCreateCompanionBuilder =
    TransferJobsCompanion Function({
      Value<int> id,
      required String peerName,
      required String peerIp,
      required String fileName,
      required int fileSize,
      Value<int> bytesTransferred,
      required String direction,
      Value<String> status,
      Value<String?> checksum,
      Value<int?> startedAt,
      Value<int?> finishedAt,
      Value<String?> savePath,
      Value<String?> errorMessage,
      Value<int> totalChunks,
      Value<int> chunksTransferred,
      Value<bool> encrypted,
      Value<String?> filePath,
      Value<int?> socketPort,
      Value<String?> sessionId,
      Value<String> peerDeviceId,
    });
typedef $$TransferJobsTableUpdateCompanionBuilder =
    TransferJobsCompanion Function({
      Value<int> id,
      Value<String> peerName,
      Value<String> peerIp,
      Value<String> fileName,
      Value<int> fileSize,
      Value<int> bytesTransferred,
      Value<String> direction,
      Value<String> status,
      Value<String?> checksum,
      Value<int?> startedAt,
      Value<int?> finishedAt,
      Value<String?> savePath,
      Value<String?> errorMessage,
      Value<int> totalChunks,
      Value<int> chunksTransferred,
      Value<bool> encrypted,
      Value<String?> filePath,
      Value<int?> socketPort,
      Value<String?> sessionId,
      Value<String> peerDeviceId,
    });

class $$TransferJobsTableFilterComposer
    extends Composer<_$AppDatabase, $TransferJobsTable> {
  $$TransferJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get peerName => $composableBuilder(
    column: $table.peerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get peerIp => $composableBuilder(
    column: $table.peerIp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytesTransferred => $composableBuilder(
    column: $table.bytesTransferred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get savePath => $composableBuilder(
    column: $table.savePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalChunks => $composableBuilder(
    column: $table.totalChunks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chunksTransferred => $composableBuilder(
    column: $table.chunksTransferred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get encrypted => $composableBuilder(
    column: $table.encrypted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get socketPort => $composableBuilder(
    column: $table.socketPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get peerDeviceId => $composableBuilder(
    column: $table.peerDeviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransferJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransferJobsTable> {
  $$TransferJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get peerName => $composableBuilder(
    column: $table.peerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get peerIp => $composableBuilder(
    column: $table.peerIp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytesTransferred => $composableBuilder(
    column: $table.bytesTransferred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get savePath => $composableBuilder(
    column: $table.savePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalChunks => $composableBuilder(
    column: $table.totalChunks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chunksTransferred => $composableBuilder(
    column: $table.chunksTransferred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get encrypted => $composableBuilder(
    column: $table.encrypted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get socketPort => $composableBuilder(
    column: $table.socketPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get peerDeviceId => $composableBuilder(
    column: $table.peerDeviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransferJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransferJobsTable> {
  $$TransferJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get peerName =>
      $composableBuilder(column: $table.peerName, builder: (column) => column);

  GeneratedColumn<String> get peerIp =>
      $composableBuilder(column: $table.peerIp, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<int> get bytesTransferred => $composableBuilder(
    column: $table.bytesTransferred,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get savePath =>
      $composableBuilder(column: $table.savePath, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalChunks => $composableBuilder(
    column: $table.totalChunks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chunksTransferred => $composableBuilder(
    column: $table.chunksTransferred,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get encrypted =>
      $composableBuilder(column: $table.encrypted, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get socketPort => $composableBuilder(
    column: $table.socketPort,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get peerDeviceId => $composableBuilder(
    column: $table.peerDeviceId,
    builder: (column) => column,
  );
}

class $$TransferJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransferJobsTable,
          TransferJob,
          $$TransferJobsTableFilterComposer,
          $$TransferJobsTableOrderingComposer,
          $$TransferJobsTableAnnotationComposer,
          $$TransferJobsTableCreateCompanionBuilder,
          $$TransferJobsTableUpdateCompanionBuilder,
          (
            TransferJob,
            BaseReferences<_$AppDatabase, $TransferJobsTable, TransferJob>,
          ),
          TransferJob,
          PrefetchHooks Function()
        > {
  $$TransferJobsTableTableManager(_$AppDatabase db, $TransferJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransferJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransferJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransferJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> peerName = const Value.absent(),
                Value<String> peerIp = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<int> bytesTransferred = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> checksum = const Value.absent(),
                Value<int?> startedAt = const Value.absent(),
                Value<int?> finishedAt = const Value.absent(),
                Value<String?> savePath = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> totalChunks = const Value.absent(),
                Value<int> chunksTransferred = const Value.absent(),
                Value<bool> encrypted = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<int?> socketPort = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<String> peerDeviceId = const Value.absent(),
              }) => TransferJobsCompanion(
                id: id,
                peerName: peerName,
                peerIp: peerIp,
                fileName: fileName,
                fileSize: fileSize,
                bytesTransferred: bytesTransferred,
                direction: direction,
                status: status,
                checksum: checksum,
                startedAt: startedAt,
                finishedAt: finishedAt,
                savePath: savePath,
                errorMessage: errorMessage,
                totalChunks: totalChunks,
                chunksTransferred: chunksTransferred,
                encrypted: encrypted,
                filePath: filePath,
                socketPort: socketPort,
                sessionId: sessionId,
                peerDeviceId: peerDeviceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String peerName,
                required String peerIp,
                required String fileName,
                required int fileSize,
                Value<int> bytesTransferred = const Value.absent(),
                required String direction,
                Value<String> status = const Value.absent(),
                Value<String?> checksum = const Value.absent(),
                Value<int?> startedAt = const Value.absent(),
                Value<int?> finishedAt = const Value.absent(),
                Value<String?> savePath = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> totalChunks = const Value.absent(),
                Value<int> chunksTransferred = const Value.absent(),
                Value<bool> encrypted = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<int?> socketPort = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<String> peerDeviceId = const Value.absent(),
              }) => TransferJobsCompanion.insert(
                id: id,
                peerName: peerName,
                peerIp: peerIp,
                fileName: fileName,
                fileSize: fileSize,
                bytesTransferred: bytesTransferred,
                direction: direction,
                status: status,
                checksum: checksum,
                startedAt: startedAt,
                finishedAt: finishedAt,
                savePath: savePath,
                errorMessage: errorMessage,
                totalChunks: totalChunks,
                chunksTransferred: chunksTransferred,
                encrypted: encrypted,
                filePath: filePath,
                socketPort: socketPort,
                sessionId: sessionId,
                peerDeviceId: peerDeviceId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransferJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransferJobsTable,
      TransferJob,
      $$TransferJobsTableFilterComposer,
      $$TransferJobsTableOrderingComposer,
      $$TransferJobsTableAnnotationComposer,
      $$TransferJobsTableCreateCompanionBuilder,
      $$TransferJobsTableUpdateCompanionBuilder,
      (
        TransferJob,
        BaseReferences<_$AppDatabase, $TransferJobsTable, TransferJob>,
      ),
      TransferJob,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MediaFoldersTableTableManager get mediaFolders =>
      $$MediaFoldersTableTableManager(_db, _db.mediaFolders);
  $$MediaFilesTableTableManager get mediaFiles =>
      $$MediaFilesTableTableManager(_db, _db.mediaFiles);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistEntriesTableTableManager get playlistEntries =>
      $$PlaylistEntriesTableTableManager(_db, _db.playlistEntries);
  $$TransferJobsTableTableManager get transferJobs =>
      $$TransferJobsTableTableManager(_db, _db.transferJobs);
}
