// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackInfo {

 int get index; String get label; String? get language;
/// Create a copy of TrackInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackInfoCopyWith<TrackInfo> get copyWith => _$TrackInfoCopyWithImpl<TrackInfo>(this as TrackInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackInfo&&(identical(other.index, index) || other.index == index)&&(identical(other.label, label) || other.label == label)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,index,label,language);

@override
String toString() {
  return 'TrackInfo(index: $index, label: $label, language: $language)';
}


}

/// @nodoc
abstract mixin class $TrackInfoCopyWith<$Res>  {
  factory $TrackInfoCopyWith(TrackInfo value, $Res Function(TrackInfo) _then) = _$TrackInfoCopyWithImpl;
@useResult
$Res call({
 int index, String label, String? language
});




}
/// @nodoc
class _$TrackInfoCopyWithImpl<$Res>
    implements $TrackInfoCopyWith<$Res> {
  _$TrackInfoCopyWithImpl(this._self, this._then);

  final TrackInfo _self;
  final $Res Function(TrackInfo) _then;

/// Create a copy of TrackInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? label = null,Object? language = freezed,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackInfo].
extension TrackInfoPatterns on TrackInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackInfo value)  $default,){
final _that = this;
switch (_that) {
case _TrackInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TrackInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String label,  String? language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackInfo() when $default != null:
return $default(_that.index,_that.label,_that.language);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String label,  String? language)  $default,) {final _that = this;
switch (_that) {
case _TrackInfo():
return $default(_that.index,_that.label,_that.language);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String label,  String? language)?  $default,) {final _that = this;
switch (_that) {
case _TrackInfo() when $default != null:
return $default(_that.index,_that.label,_that.language);case _:
  return null;

}
}

}

/// @nodoc


class _TrackInfo implements TrackInfo {
  const _TrackInfo({required this.index, required this.label, this.language});
  

@override final  int index;
@override final  String label;
@override final  String? language;

/// Create a copy of TrackInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackInfoCopyWith<_TrackInfo> get copyWith => __$TrackInfoCopyWithImpl<_TrackInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackInfo&&(identical(other.index, index) || other.index == index)&&(identical(other.label, label) || other.label == label)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,index,label,language);

@override
String toString() {
  return 'TrackInfo(index: $index, label: $label, language: $language)';
}


}

/// @nodoc
abstract mixin class _$TrackInfoCopyWith<$Res> implements $TrackInfoCopyWith<$Res> {
  factory _$TrackInfoCopyWith(_TrackInfo value, $Res Function(_TrackInfo) _then) = __$TrackInfoCopyWithImpl;
@override @useResult
$Res call({
 int index, String label, String? language
});




}
/// @nodoc
class __$TrackInfoCopyWithImpl<$Res>
    implements _$TrackInfoCopyWith<$Res> {
  __$TrackInfoCopyWithImpl(this._self, this._then);

  final _TrackInfo _self;
  final $Res Function(_TrackInfo) _then;

/// Create a copy of TrackInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? label = null,Object? language = freezed,}) {
  return _then(_TrackInfo(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PlaybackState {

 PlaybackStatus get status; int get positionMs; int get durationMs; double get speed; double get volume; bool get isMuted; bool get isFullscreen; bool get showControls; List<TrackInfo> get audioTracks; List<TrackInfo> get subtitleTracks; int? get selectedAudioTrack; int? get selectedSubtitleTrack; String? get errorMessage;
/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackStateCopyWith<PlaybackState> get copyWith => _$PlaybackStateCopyWithImpl<PlaybackState>(this as PlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackState&&(identical(other.status, status) || other.status == status)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isFullscreen, isFullscreen) || other.isFullscreen == isFullscreen)&&(identical(other.showControls, showControls) || other.showControls == showControls)&&const DeepCollectionEquality().equals(other.audioTracks, audioTracks)&&const DeepCollectionEquality().equals(other.subtitleTracks, subtitleTracks)&&(identical(other.selectedAudioTrack, selectedAudioTrack) || other.selectedAudioTrack == selectedAudioTrack)&&(identical(other.selectedSubtitleTrack, selectedSubtitleTrack) || other.selectedSubtitleTrack == selectedSubtitleTrack)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,positionMs,durationMs,speed,volume,isMuted,isFullscreen,showControls,const DeepCollectionEquality().hash(audioTracks),const DeepCollectionEquality().hash(subtitleTracks),selectedAudioTrack,selectedSubtitleTrack,errorMessage);

@override
String toString() {
  return 'PlaybackState(status: $status, positionMs: $positionMs, durationMs: $durationMs, speed: $speed, volume: $volume, isMuted: $isMuted, isFullscreen: $isFullscreen, showControls: $showControls, audioTracks: $audioTracks, subtitleTracks: $subtitleTracks, selectedAudioTrack: $selectedAudioTrack, selectedSubtitleTrack: $selectedSubtitleTrack, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PlaybackStateCopyWith<$Res>  {
  factory $PlaybackStateCopyWith(PlaybackState value, $Res Function(PlaybackState) _then) = _$PlaybackStateCopyWithImpl;
@useResult
$Res call({
 PlaybackStatus status, int positionMs, int durationMs, double speed, double volume, bool isMuted, bool isFullscreen, bool showControls, List<TrackInfo> audioTracks, List<TrackInfo> subtitleTracks, int? selectedAudioTrack, int? selectedSubtitleTrack, String? errorMessage
});




}
/// @nodoc
class _$PlaybackStateCopyWithImpl<$Res>
    implements $PlaybackStateCopyWith<$Res> {
  _$PlaybackStateCopyWithImpl(this._self, this._then);

  final PlaybackState _self;
  final $Res Function(PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? positionMs = null,Object? durationMs = null,Object? speed = null,Object? volume = null,Object? isMuted = null,Object? isFullscreen = null,Object? showControls = null,Object? audioTracks = null,Object? subtitleTracks = null,Object? selectedAudioTrack = freezed,Object? selectedSubtitleTrack = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isFullscreen: null == isFullscreen ? _self.isFullscreen : isFullscreen // ignore: cast_nullable_to_non_nullable
as bool,showControls: null == showControls ? _self.showControls : showControls // ignore: cast_nullable_to_non_nullable
as bool,audioTracks: null == audioTracks ? _self.audioTracks : audioTracks // ignore: cast_nullable_to_non_nullable
as List<TrackInfo>,subtitleTracks: null == subtitleTracks ? _self.subtitleTracks : subtitleTracks // ignore: cast_nullable_to_non_nullable
as List<TrackInfo>,selectedAudioTrack: freezed == selectedAudioTrack ? _self.selectedAudioTrack : selectedAudioTrack // ignore: cast_nullable_to_non_nullable
as int?,selectedSubtitleTrack: freezed == selectedSubtitleTrack ? _self.selectedSubtitleTrack : selectedSubtitleTrack // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackState].
extension PlaybackStatePatterns on PlaybackState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackState value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackState value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlaybackStatus status,  int positionMs,  int durationMs,  double speed,  double volume,  bool isMuted,  bool isFullscreen,  bool showControls,  List<TrackInfo> audioTracks,  List<TrackInfo> subtitleTracks,  int? selectedAudioTrack,  int? selectedSubtitleTrack,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.status,_that.positionMs,_that.durationMs,_that.speed,_that.volume,_that.isMuted,_that.isFullscreen,_that.showControls,_that.audioTracks,_that.subtitleTracks,_that.selectedAudioTrack,_that.selectedSubtitleTrack,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlaybackStatus status,  int positionMs,  int durationMs,  double speed,  double volume,  bool isMuted,  bool isFullscreen,  bool showControls,  List<TrackInfo> audioTracks,  List<TrackInfo> subtitleTracks,  int? selectedAudioTrack,  int? selectedSubtitleTrack,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PlaybackState():
return $default(_that.status,_that.positionMs,_that.durationMs,_that.speed,_that.volume,_that.isMuted,_that.isFullscreen,_that.showControls,_that.audioTracks,_that.subtitleTracks,_that.selectedAudioTrack,_that.selectedSubtitleTrack,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlaybackStatus status,  int positionMs,  int durationMs,  double speed,  double volume,  bool isMuted,  bool isFullscreen,  bool showControls,  List<TrackInfo> audioTracks,  List<TrackInfo> subtitleTracks,  int? selectedAudioTrack,  int? selectedSubtitleTrack,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.status,_that.positionMs,_that.durationMs,_that.speed,_that.volume,_that.isMuted,_that.isFullscreen,_that.showControls,_that.audioTracks,_that.subtitleTracks,_that.selectedAudioTrack,_that.selectedSubtitleTrack,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackState extends PlaybackState {
  const _PlaybackState({this.status = PlaybackStatus.idle, this.positionMs = 0, this.durationMs = 0, this.speed = 1.0, this.volume = 1.0, this.isMuted = false, this.isFullscreen = false, this.showControls = false, final  List<TrackInfo> audioTracks = const [], final  List<TrackInfo> subtitleTracks = const [], this.selectedAudioTrack, this.selectedSubtitleTrack, this.errorMessage}): _audioTracks = audioTracks,_subtitleTracks = subtitleTracks,super._();
  

@override@JsonKey() final  PlaybackStatus status;
@override@JsonKey() final  int positionMs;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  double speed;
@override@JsonKey() final  double volume;
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  bool isFullscreen;
@override@JsonKey() final  bool showControls;
 final  List<TrackInfo> _audioTracks;
@override@JsonKey() List<TrackInfo> get audioTracks {
  if (_audioTracks is EqualUnmodifiableListView) return _audioTracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audioTracks);
}

 final  List<TrackInfo> _subtitleTracks;
@override@JsonKey() List<TrackInfo> get subtitleTracks {
  if (_subtitleTracks is EqualUnmodifiableListView) return _subtitleTracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subtitleTracks);
}

@override final  int? selectedAudioTrack;
@override final  int? selectedSubtitleTrack;
@override final  String? errorMessage;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackStateCopyWith<_PlaybackState> get copyWith => __$PlaybackStateCopyWithImpl<_PlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackState&&(identical(other.status, status) || other.status == status)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isFullscreen, isFullscreen) || other.isFullscreen == isFullscreen)&&(identical(other.showControls, showControls) || other.showControls == showControls)&&const DeepCollectionEquality().equals(other._audioTracks, _audioTracks)&&const DeepCollectionEquality().equals(other._subtitleTracks, _subtitleTracks)&&(identical(other.selectedAudioTrack, selectedAudioTrack) || other.selectedAudioTrack == selectedAudioTrack)&&(identical(other.selectedSubtitleTrack, selectedSubtitleTrack) || other.selectedSubtitleTrack == selectedSubtitleTrack)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,positionMs,durationMs,speed,volume,isMuted,isFullscreen,showControls,const DeepCollectionEquality().hash(_audioTracks),const DeepCollectionEquality().hash(_subtitleTracks),selectedAudioTrack,selectedSubtitleTrack,errorMessage);

@override
String toString() {
  return 'PlaybackState(status: $status, positionMs: $positionMs, durationMs: $durationMs, speed: $speed, volume: $volume, isMuted: $isMuted, isFullscreen: $isFullscreen, showControls: $showControls, audioTracks: $audioTracks, subtitleTracks: $subtitleTracks, selectedAudioTrack: $selectedAudioTrack, selectedSubtitleTrack: $selectedSubtitleTrack, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PlaybackStateCopyWith<$Res> implements $PlaybackStateCopyWith<$Res> {
  factory _$PlaybackStateCopyWith(_PlaybackState value, $Res Function(_PlaybackState) _then) = __$PlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 PlaybackStatus status, int positionMs, int durationMs, double speed, double volume, bool isMuted, bool isFullscreen, bool showControls, List<TrackInfo> audioTracks, List<TrackInfo> subtitleTracks, int? selectedAudioTrack, int? selectedSubtitleTrack, String? errorMessage
});




}
/// @nodoc
class __$PlaybackStateCopyWithImpl<$Res>
    implements _$PlaybackStateCopyWith<$Res> {
  __$PlaybackStateCopyWithImpl(this._self, this._then);

  final _PlaybackState _self;
  final $Res Function(_PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? positionMs = null,Object? durationMs = null,Object? speed = null,Object? volume = null,Object? isMuted = null,Object? isFullscreen = null,Object? showControls = null,Object? audioTracks = null,Object? subtitleTracks = null,Object? selectedAudioTrack = freezed,Object? selectedSubtitleTrack = freezed,Object? errorMessage = freezed,}) {
  return _then(_PlaybackState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isFullscreen: null == isFullscreen ? _self.isFullscreen : isFullscreen // ignore: cast_nullable_to_non_nullable
as bool,showControls: null == showControls ? _self.showControls : showControls // ignore: cast_nullable_to_non_nullable
as bool,audioTracks: null == audioTracks ? _self._audioTracks : audioTracks // ignore: cast_nullable_to_non_nullable
as List<TrackInfo>,subtitleTracks: null == subtitleTracks ? _self._subtitleTracks : subtitleTracks // ignore: cast_nullable_to_non_nullable
as List<TrackInfo>,selectedAudioTrack: freezed == selectedAudioTrack ? _self.selectedAudioTrack : selectedAudioTrack // ignore: cast_nullable_to_non_nullable
as int?,selectedSubtitleTrack: freezed == selectedSubtitleTrack ? _self.selectedSubtitleTrack : selectedSubtitleTrack // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
